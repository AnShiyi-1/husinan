@echo off
:: Fix encoding issues and prepare for deployment
chcp 65001 >nul

echo === Vercel Deployment Fix ===
echo.

:: Clean up problematic files
echo Cleaning up...
if exist "vercel.json" del "vercel.json"
if exist ".env.production" del ".env.production"

:: Create clean vercel.json
echo Creating Vercel configuration...
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

echo === Ready to Deploy ===
echo.
echo 1. Run: npm install
2. Run: npm run build
3. Run: vercel --prod
echo.
echo Or simply run: simple-deploy.bat
pause