@echo off
chcp 65001
cls
echo 正在检查已部署的Vercel项目...
echo.

:: 检查Vercel CLI是否安装
vercel --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Vercel CLI未安装
    echo 请先运行: npm install -g vercel
    pause
    exit /b
)

echo ✅ Vercel CLI已安装

:: 获取当前项目的域名
echo.
echo 正在获取当前项目的域名...
echo.

:: 检查当前目录是否已链接到Vercel项目
if exist .vercel\project.json (
    echo ✅ 项目已链接到Vercel
    echo.
    echo 项目信息:
    vercel inspect
    echo.
    echo 访问地址:
    for /f "tokens=*" %%i in ('vercel ls --json 2^>nul ^| findstr /i "url"') do (
        echo %%i
    )
) else (
    echo ⚠️ 项目尚未链接到Vercel
    echo.
    echo 请先运行以下命令进行部署:
    echo   vercel --prod
    echo.
    echo 或者运行一键部署脚本: 一键修复部署.bat
)

echo.
pause