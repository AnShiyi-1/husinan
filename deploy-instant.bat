@echo off
title Instant Deploy - No Authentication Required
color 2f

echo.
echo ======================================
echo    Instant Deploy - Zero Authentication
echo ======================================
echo.

:menu
echo Choose your deployment:
echo.
echo [1] GitHub Pages (30 seconds, free)
echo [2] Local Test (instant, offline)
echo [3] Netlify Fixed (1 minute)
echo [4] Surge.sh (command line)
echo [0] Exit
echo.
set /p choice=Enter choice (0-4): 

if "%choice%"=="1" goto github
if "%choice%"=="2" goto local
if "%choice%"=="3" goto netlify
if "%choice%"=="4" goto surge
if "%choice%"=="0" goto exit

echo Invalid choice, try again!
goto menu

:github
echo.
echo Opening GitHub Pages deployment...
start https://github.com/new
echo.
echo Steps:
echo 1. Create new repository
echo 2. Upload dist folder contents
echo 3. Enable GitHub Pages in settings
echo 4. Done! Free forever
pause
goto menu

:local
echo.
echo Opening local test version...
start local-test.html
echo.
echo ✅ Local version working!
echo No internet required
echo.
pause
goto menu

:netlify
echo.
echo Creating fixed Netlify package...
powershell -Command "Compress-Archive -Path 'dist\*' -DestinationPath 'netlify-no-auth.zip' -Force"
echo.
echo Opening Netlify...
start https://app.netlify.com/drop
start netlify-no-auth.zip
echo Upload netlify-no-auth.zip
pause
goto menu

:surge
echo.
echo To deploy with Surge.sh:
echo 1. npm install -g surge
echo 2. surge dist
echo 3. Done! Instant deployment
pause
goto menu

:exit
echo Thank you! Press any key to exit...
pause > nul