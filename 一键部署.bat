@echo off
title 情绪画布一键部署工具
color 0A

echo ╔═══════════════════════════════════════╗
echo ║        情绪画布一键部署工具           ║
echo ╚═══════════════════════════════════════╝
echo.

:: 检查管理员权限
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo 请以管理员身份运行此脚本！
    echo 右键点击此文件，选择"以管理员身份运行"
    pause
    exit /b 1
)

:: 检查网络连接
ping -n 1 google.com >nul 2>&1
if errorlevel 1 (
    echo 网络连接失败，请检查网络！
    pause
    exit /b 1
)

:: 检查Node.js
echo 检查Node.js环境...
node --version >nul 2>&1
if errorlevel 1 (
    echo Node.js未安装，正在打开下载页面...
    start https://nodejs.org/zh-cn/download/
    echo 请安装Node.js后重新运行此脚本
    pause
    exit /b 1
)

echo ✅ Node.js已安装

:: 检查npm
echo 检查npm环境...
npm --version >nul 2>&1
if errorlevel 1 (
    echo npm未正确安装
    pause
    exit /b 1
)

echo ✅ npm已安装

:: 进入项目目录
cd /d "%~dp0"
echo 当前目录: %CD%

:: 安装依赖
echo.
echo 正在安装项目依赖...
echo 这可能需要几分钟时间...
call npm install --production
if errorlevel 1 (
    echo 依赖安装失败！
    echo 请检查网络连接或手动运行: npm install
    pause
    exit /b 1
)

echo ✅ 依赖安装完成

:: 构建项目
echo.
echo 正在构建项目...
call npm run build
if errorlevel 1 (
    echo 构建失败！
    echo 请检查代码错误或手动运行: npm run build
    pause
    exit /b 1
)

echo ✅ 项目构建完成

:: 检查Vercel CLI
echo.
echo 检查Vercel CLI...
where vercel >nul 2>&1
if errorlevel 1 (
    echo 正在安装Vercel CLI...
    call npm install -g vercel
    if errorlevel 1 (
        echo Vercel CLI安装失败！
        echo 请手动运行: npm install -g vercel
        pause
        exit /b 1
    )
)

echo ✅ Vercel CLI已就绪

:: 开始部署
echo.
echo ╔═══════════════════════════════════════╗
echo ║           准备部署到Vercel              ║
echo ╚═══════════════════════════════════════╝
echo.
echo 请按以下步骤操作：
echo 1. 登录Vercel账号（或注册新账号）
echo 2. 选择部署项目
necho 3. 设置环境变量（可选）
echo 4. 完成部署

:: 启动部署
echo.
echo 正在启动Vercel部署...
timeout /t 2 >nul
start cmd /k "cd /d "%~dp0" && vercel --prod"

echo.
echo 🎉 部署界面已打开！
echo 请在新窗口中按提示完成部署
pause