@echo off
title Git安装助手
color 2f

echo.
echo ======================================
echo    Git安装助手 - 一键解决命令问题
echo ======================================
echo.

:: 检查是否已安装Git
git --version >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Git已安装！
    git --version
    echo.
    echo 正在配置Git...
    git config --global user.name "AnShiyi-1"
    git config --global user.email "anshiyi@example.com"
    echo ✅ Git配置完成！
    pause
    exit /b 0
)

echo ❌ 未检测到Git，正在准备安装...

:: 提供安装选项
echo.
echo 请选择安装方式：
echo [1] 自动下载安装Git for Windows
echo [2] 打开Git官网手动下载
echo [3] 使用无需Git的GitHub上传方案
echo [4] 跳过（使用GitHub网页上传）
echo.

set /p choice="请输入选项 [1-4]: "

if "%choice%"=="1" (
    echo 正在下载Git for Windows...
    start https://github.com/git-for-windows/git/releases/download/v2.42.0.windows.2/Git-2.42.0.2-64-bit.exe
    echo.
    echo 📥 下载完成后，请运行下载的安装程序
    echo 📋 保持默认设置，确保勾选"添加到PATH"
    echo 🔄 安装完成后重新打开终端
    pause
)

if "%choice%"=="2" (
    start https://git-scm.com/download/win
    echo 📱 已打开Git官网，请下载Windows版本
    pause
)

if "%choice%"=="3" (
    echo 🌐 使用GitHub网页上传方案...
    start https://github.com/AnShiyi-1/qxhb/upload/main
    echo.
    echo 📁 无需Git，直接拖拽文件上传即可
    echo 📋 上传dist文件夹中的所有文件
    pause
)

if "%choice%"=="4" (
    echo 🚀 使用GitHub网页方案...
    start https://github.com/AnShiyi-1/qxhb
    echo.
    echo 📋 点击"Add file" → "Upload files"上传文件
    pause
)

echo.
echo 🎉 操作完成！
echo 如果安装了Git，请重新打开终端使用git命令