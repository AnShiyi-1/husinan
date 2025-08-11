@echo off
title 一键部署到GitHub Pages
echo.
echo ==================================
echo    情绪画布 - GitHub部署工具
echo ==================================
echo.

:: 检查是否已安装Git
git --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Git未安装，请先安装Git
    echo 下载地址: https://git-scm.com/download/win
    pause
    exit /b 1
)

:: 设置变量
set REPO_URL=https://github.com/AnShiyi-1/qxhb.git
set PROJECT_NAME=emotion-canvas

:: 创建临时目录进行上传
echo 📁 准备上传项目...
set TEMP_DIR=%TEMP%\%PROJECT_NAME%-%RANDOM%
mkdir "%TEMP_DIR%"

:: 复制必要文件
echo 📦 复制项目文件...
xcopy /E /I /Y "src" "%TEMP_DIR%\src\" >nul
xcopy /E /I /Y "public" "%TEMP_DIR%\public\" >nul
xcopy /E /I /Y "server" "%TEMP_DIR%\server\" >nul
copy /Y "package.json" "%TEMP_DIR%\" >nul
copy /Y "vite.config.js" "%TEMP_DIR%\" >nul
copy /Y "index.html" "%TEMP_DIR%\" >nul
copy /Y "README.md" "%TEMP_DIR%\" >nul

:: 进入临时目录
cd /d "%TEMP_DIR%"

:: 初始化Git仓库
echo 🔄 初始化Git仓库...
git init
git config --global user.email "deploy@example.com"
git config --global user.name "Deploy Bot"

:: 添加所有文件
echo 📋 添加文件...
git add .
git commit -m "Initial commit: Emotion Canvas project"

:: 推送到GitHub
echo 🚀 推送到GitHub...
git remote add origin %REPO_URL%
git branch -M main
git push -u origin main --force

:: 返回原目录
cd /d "c:\Users\Firday1\Desktop\绘画软件"

:: 清理临时文件
rmdir /S /Q "%TEMP_DIR%"

echo.
echo ✅ 上传完成！
echo.
echo 🌐 访问项目: %REPO_URL%
echo 📖 GitHub Pages将在几分钟后自动部署
echo.
echo 🔗 在线地址: https://AnShiyi-1.github.io/qxhb
pause