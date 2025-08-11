@echo off
title Update Configuration After Deployment
color 0B

echo =====================================
echo Update API Configuration
echo =====================================
echo.

:: Get domain from user
echo Enter your Vercel domain:
echo Example: your-app-name.vercel.app
set /p domain=Domain: 

if "%domain%"=="" (
    echo ERROR: Domain cannot be empty!
    pause
    exit /b 1
)

:: Ensure https prefix
if not "%domain:~0,8%"=="https://" (
    set full_domain=https://%domain%
) else (
    set full_domain=%domain%
)

echo.
echo Updating configuration with: %full_domain%

:: Update environment file
echo NODE_ENV=production > .env.production
echo VITE_API_BASE_URL=%full_domain%/api >> .env.production

echo.
echo Configuration updated!
echo.
echo Rebuilding project...
npm run build

echo.
echo =====================================
echo Configuration Complete!
echo =====================================
echo.
echo Your API URL: %full_domain%/api
echo.
echo Next step: Redeploy to Vercel
echo Run: vercel --prod
pause