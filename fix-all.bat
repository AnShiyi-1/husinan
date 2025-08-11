@echo off
title Emotion Canvas - Complete Fix Solution
color 1f

:menu
echo.
echo ======================================
echo      Emotion Canvas - Fix Solution
echo ======================================
echo.
echo Choose deployment method:
echo.
echo [1] Tencent CloudBase (China accessible)
echo [2] Local test (immediate use)
echo [3] GitHub Pages (free)
echo [4] Rebuild and fix Netlify
necho [5] Check current status
necho [0] Exit
echo.
set /p choice=Enter choice (0-5): 

if "%choice%"=="1" goto tencent
if "%choice%"=="2" goto local
if "%choice%"=="3" goto github
if "%choice%"=="4" goto netlify
if "%choice%"=="5" goto status
if "%choice%"=="0" goto exit

echo Invalid choice, please try again!
goto menu

:tencent
echo.
echo Opening Tencent CloudBase deployment...
start https://console.cloud.tencent.com/tcb/hosting
start https://console.cloud.tencent.com/tcb/env/index
start dist.zip
echo.
echo Steps:
echo 1. Login to Tencent Cloud
echo 2. Create environment and select static hosting
echo 3. Upload dist.zip file
echo 4. Deploy and get China-accessible URL
pause
goto menu

:local
echo.
echo Opening local test version...
start local-test.html
echo.
echo Local test version opened!
echo If local works, the code is fine
pause
goto menu

:github
echo.
echo Opening GitHub Pages deployment...
start https://github.com/new
echo.
echo Steps:
echo 1. Create new repository (e.g., emotion-canvas)
echo 2. Upload dist folder contents
necho 3. Enable GitHub Pages in repository settings
pause
goto menu

:netlify
echo.
echo Rebuilding project...
call npm run build

if %errorlevel% neq 0 (
    echo Build failed, check npm environment
    pause
    goto menu
)

echo.
echo Fixing path issues...
powershell -Command "(Get-Content dist\index.html) -replace 'href=\"/emotion-icon.svg\"', 'href=\"./emotion-icon.svg\"' | Set-Content dist\index.html"

echo.
echo Creating fixed package...
powershell -Command "Compress-Archive -Path 'dist\*' -DestinationPath 'netlify-final-fix.zip' -Force"

echo.
echo Fix complete!
echo Opening Netlify...
start https://app.netlify.com/drop
start netlify-final-fix.zip
echo Upload netlify-final-fix.zip to Netlify
pause
goto menu

:status
echo.
echo Current project status:
echo.
echo Available packages:
dir *.zip /b
echo.
echo Dist folder contents:
dir dist /b
echo.
echo Available tests:
echo - Local test: local-test.html
echo - Tencent: fix-all.bat option 1
echo - Fixed version: netlify-final-fix.zip
pause
goto menu

:exit
echo.
echo Thank you! Press any key to exit...
pause > nul