import json
import os
import re
import sqlite3
import threading
import webbrowser
from pathlib import Path

from dotenv import load_dotenv
from flask import Flask, render_template, request
from openai import APIConnectionError, APIStatusError, AuthenticationError, OpenAI, RateLimitError

BASE_DIR = Path(__file__).resolve().parent
DB_PATH = BASE_DIR / "blood_donation.sqlite3"
app = Flask(__name__)
app.config["MAX_CONTENT_LENGTH"] = 16 * 1024


def initialize_database():
    with sqlite3.connect(DB_PATH) as connection:
        connection.execute("PRAGMA foreign_keys = ON")
        connection.executescript((BASE_DIR / "schema.sql").read_text(encoding="utf-8"))
        connection.executescript((BASE_DIR / "seed.sql").read_text(encoding="utf-8"))


def schema_description():
    with sqlite3.connect(DB_PATH) as connection:
        rows = connection.execute(
            "SELECT name, sql FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%' ORDER BY name"
        ).fetchall()
    return "\n\n".join(f"{name}:\n{sql}" for name, sql in rows)


def generate_sql(client, question):
    response = client.responses.create(
        model=os.getenv("OPENAI_MODEL", "gpt-4.1-mini"),
        instructions=(
            "Translate the user's question into exactly one read-only SQLite SELECT query. "
            "Use only tables and columns in the supplied schema. Never modify data or schema. "
            "Return only JSON with one string field named sql. Do not include markdown."
        ),
        input=f"Schema:\n{schema_description()}\n\nQuestion:\n{question}",
    )
    text = response.output_text.strip()
    fenced = re.fullmatch(r"```(?:json|sql)?\s*(.*?)\s*```", text, re.IGNORECASE | re.DOTALL)
    if fenced:
        text = fenced.group(1).strip()
    try:
        payload = json.loads(text)
        if isinstance(payload, dict):
            text = payload.get("sql", "")
    except json.JSONDecodeError:
        pass
    if not isinstance(text, str) or not text.strip():
        raise ValueError("The model did not return a SQL query.")
    text = re.sub(r"^sql\s*[:\n]+", "", text.strip(), flags=re.IGNORECASE)
    return text.strip().rstrip(";").strip()


def validate_sql(sql):
    normalized = sql.strip()
    if not re.match(r"^(SELECT|WITH)\b", normalized, re.IGNORECASE):
        raise ValueError("Only read-only SELECT queries are allowed.")
    if ";" in normalized:
        raise ValueError("Only one SQL statement is allowed.")
    denied = re.compile(r"\b(INSERT|UPDATE|DELETE|DROP|ALTER|CREATE|REPLACE|ATTACH|DETACH|PRAGMA|VACUUM|REINDEX)\b", re.I)
    if denied.search(normalized):
        raise ValueError("The generated query contains a disallowed operation.")
    return normalized


def run_query(sql):
    uri = f"file:{DB_PATH.as_posix()}?mode=ro"
    with sqlite3.connect(uri, uri=True, timeout=5) as connection:
        connection.row_factory = sqlite3.Row
        connection.set_progress_handler(lambda: 1, 100_000)
        cursor = connection.execute(sql)
        columns = [item[0] for item in cursor.description or []]
        rows = [dict(row) for row in cursor.fetchmany(201)]
    truncated = len(rows) > 200
    return columns, rows[:200], truncated


@app.route("/", methods=["GET", "POST"])
def index():
    question = ""
    answer = None
    sql = None
    columns = []
    rows = []
    truncated = False
    error = None

    if request.method == "POST":
        question = request.form.get("question", "").strip()
        if not question:
            error = "Enter a question to get started."
        else:
            load_dotenv(BASE_DIR / ".env")
            if not os.getenv("openai_api_key"):
                error = "The openai_api_key variable is missing from .env."
            else:
                stage = "sql"
                try:
                    client = OpenAI(api_key=os.getenv("openai_api_key"))
                    sql = validate_sql(generate_sql(client, question))
                    stage = "database"
                    columns, rows, truncated = run_query(sql)
                    summary = json.dumps(rows, ensure_ascii=False, default=str)
                    stage = "answer"
                    response = client.responses.create(
                        model=os.getenv("OPENAI_MODEL", "gpt-4.1-mini"),
                        instructions="Answer the user's question using only the database results provided. Be clear and concise. If no rows were found, say so.",
                        input=f"Question: {question}\nDatabase result rows: {summary}",
                    )
                    answer = response.output_text
                except AuthenticationError:
                    error = "OpenAI rejected the configured API key. Check that the key is valid and enabled."
                except RateLimitError:
                    error = "OpenAI is rate limiting requests or the project has no available API quota. Try again later."
                except APIConnectionError:
                    error = "Could not reach OpenAI. Check your internet connection and try again."
                except APIStatusError:
                    error = "OpenAI could not complete the request. Check model access and API settings, then try again."
                except ValueError:
                    error = "I couldn't create a safe SQL query from that question. Try asking in a different way."
                except sqlite3.Error:
                    error = "The generated query could not run on this database. Try making the question more specific."
                except Exception:
                    # Do not expose SDK details or request metadata, which may contain secrets.
                    app.logger.error("Question processing failed.")
                    if stage == "answer":
                        error = "The database query worked, but I couldn't format the answer. You can still see the query and results below."
                    elif stage == "database":
                        error = "The SQL was created, but the database could not return results. Try a more specific question."
                    else:
                        error = "I couldn't create a database query. Check the model settings and try a more specific question."

    return render_template("index.html", question=question, answer=answer, sql=sql,
                           columns=columns, rows=rows, truncated=truncated, error=error)


initialize_database()

if __name__ == "__main__":
    threading.Timer(1.2, lambda: webbrowser.open("http://127.0.0.1:5000")).start()
    app.run(debug=False)
