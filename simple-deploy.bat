@echo off
:: Simple Vercel Deploy Script
:: Just run this and follow the prompts

echo Starting Vercel deployment...
echo.

:: Check if Node.js exists
node --version >nul 2>&1
if errorlevel 1 (
    echo Please install Node.js first
    pause
    exit /b 1
)

:: Install dependencies
echo Installing dependencies...
call npm install

:: Build project
echo Building project...
call npm run build

:: Deploy to Vercel
echo.
echo Opening Vercel deployment...
echo Follow the prompts in the new window
echo.
start cmd /k "vercel --prod"

echo Deployment started! Check the new window for progress.
pause