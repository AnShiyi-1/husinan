@echo off
title 情绪画布本地服务器
color 0A

echo ╔═══════════════════════════════════════╗
echo ║        情绪画布本地服务器             ║
echo ╚═══════════════════════════════════════╝
echo.

:: 检查Node.js
node --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Node.js未安装
    echo 请先安装Node.js: https://nodejs.org/
    pause
    exit /b 1
)

:: 进入项目目录
cd /d "%~dp0"

echo 正在启动服务器...
echo.
echo 访问地址: http://localhost:3000
echo 按 Ctrl+C 停止服务器
echo.
echo ═══════════════════════════════════════════

:: 启动服务器
node server/index.js

pause