@echo off
chcp 65001
cls
echo.
echo    🚨 GitHub Pages 404 错误修复工具
echo    =================================
echo.
echo 正在为您修复GitHub Pages 404错误...
echo.

:: 检查是否已构建
if not exist "dist\index.html" (
    echo ❌ 错误：未找到构建文件！
    echo.
    echo 请先运行：npm run build
    pause
    exit /b 1
)

echo ✅ 构建文件已找到
echo.

:: 创建可直接上传的压缩包
echo 正在准备上传文件...
if exist "github-upload-ready.zip" del "github-upload-ready.zip"

:: 使用PowerShell创建压缩包
powershell -Command "Compress-Archive -Path 'dist\index.html', 'dist\assets', 'dist\*.svg' -DestinationPath 'github-upload-ready.zip' -Force"

echo ✅ 部署包已创建：github-upload-ready.zip
echo.

:: 打开GitHub仓库
echo 正在打开GitHub仓库...
start https://github.com/AnShiyi-1/qxhb

echo.
echo 📋 修复步骤：
echo.
echo 1. 在打开的GitHub页面中，点击 "Add file" → "Upload files"
echo 2. 解压 github-upload-ready.zip 并上传所有文件
echo 3. 等待5分钟后访问：https://anshiyi-1.github.io/qxhb
echo.
echo 📁 文件位置：%CD%\github-upload-ready.zip
echo.
echo 按任意键打开部署文件夹...
pause
start dist
echo.
echo 🎯 修复完成！请按上述步骤操作。
pause