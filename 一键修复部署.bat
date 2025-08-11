@echo off
title 一键修复部署
color 0a
echo.
echo ╔═══════════════════════════════════════╗
echo ║        情绪画布Vercel部署修复         ║
echo ╚═══════════════════════════════════════╝
echo.

:: 设置编码
chcp 65001 >nul

:: 检查Node.js
node --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Node.js未安装
    echo 📥 请访问：https://nodejs.org 下载并安装
    pause
    exit /b 1
)

:: 检查并安装Vercel CLI
echo 📦 检查Vercel CLI...
vercel --version >nul 2>&1
if errorlevel 1 (
    echo 📥 正在安装Vercel CLI...
    call npm install -g vercel
)

:: 清理旧文件
echo 🧹 清理旧文件...
if exist "dist" rmdir /s /q dist
if exist ".vercel" rmdir /s /q .vercel

:: 安装依赖
echo 📦 安装项目依赖...
call npm install

:: 构建项目
echo 🔨 构建项目...
call npm run build

:: 开始部署
echo 🚀 开始部署...
echo.
echo 💡 按提示操作：
echo 1. 登录Vercel账号
echo 2. 选择项目设置
echo 3. 确认部署
echo.

vercel --prod

echo.
echo ✅ 部署完成！
echo 🌐 访问你的应用：
vercel ls --limit 1
pause