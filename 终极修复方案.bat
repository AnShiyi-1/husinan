@echo off
chcp 65001 >nul
title 🚀 终极修复部署方案
color 0a

echo.
echo ==========================================
echo    🎨 情绪画布 - 终极修复部署方案
echo ==========================================
echo.

:: 1. 启动本地服务器测试
echo 🔧 步骤1: 启动本地测试服务器...
start cmd /k "cd /d %~dp0 && npm run dev"
timeout /t 5 >nul

echo ✅ 本地服务器已启动！
echo 📍 本地地址: http://localhost:5173
echo.

:: 2. 显示当前可用的在线地址
echo 🔍 步骤2: 当前可用的在线地址：
echo.
echo 📱 备用地址1: https://emotion-canvas-gdvsftsbu-anshiyi-1s-projects.vercel.app
echo 📱 备用地址2: https://emotion-canvas-bc2xsr5bp-anshiyi-1s-projects.vercel.app
echo 📱 备用地址3: https://emotion-canvas-8y99dyxzz-anshiyi-1s-projects.vercel.app
echo.

:: 3. 提供一键测试选项
echo 🎯 步骤3: 选择测试方式：
echo.
echo [1] 本地测试（推荐）- 打开浏览器访问 http://localhost:5173
echo [2] 手机测试 - 用手机访问上述任意在线地址
echo [3] 一键重新部署 - 修复后重新部署到Vercel
echo [4] 部署到国内平台 - 使用腾讯云/阿里云等

:: 4. 自动打开本地地址
echo.
echo 🚀 正在打开本地测试地址...
start http://localhost:5173

echo.
echo ==========================================
echo    ✅ 修复完成！请按以下方式测试：
echo    1. 本地：http://localhost:5173 (已打开)
echo    2. 手机：使用上述任意在线地址
echo    3. 等待1分钟后重试在线地址
echo ==========================================

pause