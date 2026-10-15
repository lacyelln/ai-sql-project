@echo off
cd /d "%~dp0"

if not exist ".venv\Scripts\python.exe" (
    py -m venv .venv
    if errorlevel 1 goto error
)

".venv\Scripts\python.exe" -c "import flask, openai, dotenv" >nul 2>&1
if errorlevel 1 (
    echo Installing the app's Python packages...
    ".venv\Scripts\python.exe" -m pip install -r requirements.txt
    if errorlevel 1 goto error
)

".venv\Scripts\python.exe" app.py
if errorlevel 1 goto error
goto end

:error
echo.
echo The app could not start. Check that Python is installed and try again.
pause

:end
