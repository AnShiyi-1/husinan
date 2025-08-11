@echo off
chcp 65001
title 🎯 免费后端平台选择器 - 一键部署
cls
echo.
echo ======================================
echo     🎯 免费后端平台选择器
     5个平台一键部署方案
======================================
echo.

:menu
echo.
echo 请选择要部署的免费后端平台：
echo.
echo 1️⃣  🎯 Render - 完整PostgreSQL后端
2️⃣  🚀 Fly.io - 全球CDN加速
3️⃣  🌸 Heroku - 经典免费平台
4️⃣  🌤️ 腾讯云CloudBase - 国内最快
5️⃣  📋 查看所有平台对比
6️⃣  ❌ 退出

echo.
set /p choice=请输入选择(1-6): 

echo.
if "%choice%"=="1" (
    echo 🎯 正在启动Render部署...
    start cmd /k "cd /d "%~dp0" && call 部署到Render.bat"
    goto menu
)

if "%choice%"=="2" (
    echo 🚀 正在启动Fly.io部署...
    start cmd /k "cd /d "%~dp0" && call 部署到Flyio.bat"
    goto menu
)

if "%choice%"=="3" (
    echo 🌸 正在启动Heroku部署...
    start cmd /k "cd /d "%~dp0" && call 部署到Heroku.bat"
    goto menu
)

if "%choice%"=="4" (
    echo 🌤️ 正在启动腾讯云CloudBase部署...
    start cmd /k "cd /d "%~dp0" && call 部署到腾讯云CloudBase.bat"
    goto menu
)

if "%choice%"=="5" (
    echo 📋 正在打开平台对比...
    start notepad "免费后端平台对比.txt"
    goto menu
)

if "%choice%"=="6" (
    echo 👋 感谢使用，再见！
    timeout /t 2 >nul
    exit
)

echo ❌ 无效选择，请重新输入！
timeout /t 2 >nul
goto menu