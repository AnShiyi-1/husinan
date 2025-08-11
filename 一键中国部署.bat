@echo off
title 中国可访问一键部署
color 2f
echo.
echo  ██████╗ ██╗   ██╗██╗██╗     ██████╗ ███████╗██████╗ 
echo  ██╔══██╗██║   ██║██║██║     ██╔══██╗██╔════╝██╔══██╗
echo  ██████╔╝██║   ██║██║██║     ██║  ██║█████╗  ██║  ██║
echo  ██╔══██╗██║   ██║██║██║     ██║  ██║██╔══╝  ██║  ██║
echo  ██████╔╝╚██████╔╝██║███████╗██████╔╝███████╗██████╔╝
echo  ╚═════╝  ╚═════╝ ╚═╝╚══════╝╚═════╝ ╚══════╝╚═════╝ 
echo.
echo 正在为您部署中国可访问的版本...
echo.

REM 步骤1：重新构建项目
echo [1/3] 重新构建项目...npm run build
npm run build
if %errorlevel% neq 0 (
    echo ❌ 构建失败，请检查项目
    pause
    exit /b
)

REM 步骤2：部署到Netlify（中国可访问）
echo [2/3] 正在部署到Netlify（中国可访问）...
echo 正在打开Netlify拖拽页面...
start https://app.netlify.com/drop
timeout /t 3 >nul

echo 正在打开dist文件夹...
start dist
echo.
echo ✅ 操作完成！
echo.
echo 📋 下一步操作：
echo 1. 将dist文件夹拖拽到Netlify页面
echo 2. 等待部署完成
echo 3. 获得中国可访问的网站地址
echo.
echo 🌐 预计网站地址格式：https://[随机名称].netlify.app
echo 📱 这个地址在中国可以正常访问！
echo.
pause