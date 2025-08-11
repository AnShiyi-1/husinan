@echo off
chcp 65001
title 🎨 情绪画布 - 一键上网版
:menu
cls
echo.
echo ======================================
echo     🎨 情绪画布 - 一键上网启动器
echo ======================================
echo.
echo 请选择操作：
echo.
echo 1️⃣  验证项目状态
echo 2️⃣  免费部署到网上
echo 3️⃣  查看部署指南
echo 4️⃣  打开项目目录
echo 5️⃣  退出
echo.
set /p choice=请输入选项 (1-5): 

if "%choice%"=="1" (
    call "部署验证工具.bat"
    goto menu
)

if "%choice%"=="2" (
    call "免费部署到网上.bat"
    goto menu
)

if "%choice%"=="3" (
    start notepad "免费部署完整指南.txt"
    goto menu
)

if "%choice%"=="4" (
    start "" "%cd%"
    goto menu
)

if "%choice%"=="5" (
    exit
)

echo 无效选择，请重试...
timeout /t 2 >nul
goto menu