@echo off
chcp 65001
cls
title 🚀 免费部署到Vercel - 一键完成
echo.
echo ======================================
echo     🎨 情绪画布 - 免费部署到网上
echo ======================================
echo.

:: 1. 环境检查
echo 🔍 检查环境...
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Node.js 未安装
    echo 📥 请访问 https://nodejs.org 下载安装
    pause
    exit /b
)

echo ✅ Node.js 已安装

:: 2. 检查Vercel CLI
vercel --version >nul 2>&1
if %errorlevel% neq 0 (
    echo 📦 正在安装 Vercel CLI...
    npm install -g vercel
)

echo ✅ Vercel CLI 已就绪

:: 3. 安装依赖
echo.
echo 📦 安装项目依赖...
call npm install
if %errorlevel% neq 0 (
    echo ❌ 依赖安装失败
    pause
    exit /b
)

:: 4. 构建项目
echo.
echo 🔨 构建项目...
call npm run build
if %errorlevel% neq 0 (
    echo ❌ 构建失败
    pause
    exit /b
)

:: 5. 部署到Vercel
echo.
echo 🚀 开始部署到Vercel...
echo.
echo ⚠️  接下来请按以下步骤操作：
echo    1. 选择 GitHub 登录方式
echo    2. 选择你的项目范围 (anshiyi-1's projects)
echo    3. 使用默认项目名称
echo    4. 其他设置保持默认即可
echo.

:: 创建临时部署脚本
echo vercel --prod --yes > temp_deploy.bat
echo pause >> temp_deploy.bat
start cmd /k temp_deploy.bat

:: 6. 清理
timeout /t 3 >nul
del temp_deploy.bat 2>nul

echo.
echo ✅ 部署命令已发送！
echo 📱 部署完成后，你会看到一个以 .vercel.app 结尾的网址
echo 💡 这就是你的免费在线应用地址
echo.
pause