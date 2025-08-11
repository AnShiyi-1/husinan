@echo off
:: Vercel Deployment Script - English Version
title Vercel Deployment Tool
color 0A

:: Prevent encoding issues
chcp 65001 >nul

:: Create log file
echo [%date% %time%] Starting Vercel deployment > deployment.log

:: Check Node.js
node --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Node.js not found!
    echo Please install Node.js from https://nodejs.org/
    pause
    exit /b 1
)

echo Node.js detected: 
node --version

:: Check Vercel CLI
where vercel >nul 2>&1
if errorlevel 1 (
    echo Installing Vercel CLI...
    npm install -g vercel
)

echo Vercel CLI ready!

:: Change to project directory
cd /d "%~dp0"

echo.
echo =====================================
echo STEP 1: Install Dependencies
echo =====================================
echo.

npm install
if errorlevel 1 (
    echo ERROR: Failed to install dependencies!
    pause
    exit /b 1
)

echo.
echo =====================================
echo STEP 2: Build Project
echo =====================================
echo.

npm run build
if errorlevel 1 (
    echo ERROR: Build failed!
    pause
    exit /b 1
)

echo.
echo =====================================
echo STEP 3: Create Vercel Config
echo =====================================
echo.

:: Create optimized vercel.json
(
echo {
echo   "version": 2,
echo   "builds": [
echo     {
echo       "src": "server/index.js",
echo       "use": "@vercel/node"
echo     }
echo   ],
echo   "routes": [
echo     {
echo       "src": "/api/(.*)",
echo       "dest": "server/index.js"
echo     },
echo     {
echo       "src": "/(.*)",
echo       "dest": "/dist/$1"
echo     }
echo   ]
echo }
) > vercel.json

echo Vercel config created!

echo.
echo =====================================
echo STEP 4: Deploy to Vercel
echo =====================================
echo.
echo Ready to deploy!
echo Press ENTER to start Vercel deployment...
pause

echo.
echo Starting Vercel deployment...
echo A new window will open - follow the prompts to complete deployment
start cmd /k "cd /d "%~dp0" && echo Deploying to Vercel... && vercel --prod"

echo.
echo =====================================
echo DEPLOYMENT COMPLETE!
echo =====================================
echo.
echo After deployment:
echo 1. Copy your Vercel domain (e.g., https://your-app.vercel.app)
echo 2. Run update-config.bat with your domain
pause