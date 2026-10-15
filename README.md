# Blood Donation Data Assistant

A small Flask app backed by SQLite and modeled on `ERD2.png`. It includes the ERD entities and relationships, sample fictional records, and a natural language question interface.

## Run locally

1. Create and activate a virtual environment, then install dependencies:

   ```powershell
   py -m venv .venv
   .\.venv\Scripts\Activate.ps1
   pip install -r requirements.txt
   ```

2. In the existing `.env` file, set `openai_api_key` to your API key. The app reads the variable at runtime; it does not display or log its value. Optionally set `OPENAI_MODEL` to change the default model (`gpt-4.1-mini`).

3. Start the app by double-clicking `run_app.bat`. It opens the app in your browser. You can also start it from PowerShell:

   ```powershell
   py app.py
   ```

If you start it from PowerShell, open http://127.0.0.1:5000. Keep the app window open while asking questions. Do not open `templates/index.html` directly; the page needs the Flask server to process the form and talk to GPT.

The database file `blood_donation.sqlite3` is created automatically on startup. To recreate a blank database structure, delete that generated file and replace `seed.sql` with an empty file before the next run. SQL is restricted to one read-only `SELECT` query and is executed against a read-only database connection. Up to 200 result rows are returned.

## Schema notes

`donation.date` follows the ERD's date field (shown as `data` in the diagram). Donor and staff each have their own integer ID and a unique `person_id` foreign key. Names/phone numbers are text, allowing leading zeros and nonnumeric formats; donation quantities and pay rates are numeric.
