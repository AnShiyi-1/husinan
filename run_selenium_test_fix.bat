@echo off

REM Check if Python is installed
python --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo Error: Python is not found. Please install Python first.
    pause
    exit /b 1
)

REM Install required dependencies
echo Installing required dependencies...
pip install selenium webdriver-manager
if %ERRORLEVEL% NEQ 0 (
    echo Error: Failed to install dependencies.
    pause
    exit /b 1
)

REM Remind user to modify test account
echo Please make sure to modify the test account and password in selenium_test.py.
echo Press any key to continue...
pause >nul

REM Run test script
python selenium_test.py
if %ERRORLEVEL% NEQ 0 (
    echo Error: Test script execution failed.
    pause
    exit /b 1
)

REM Test completed
echo Test execution completed.
pause