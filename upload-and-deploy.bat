@echo off
title 一键上传到GitHub并部署
echo.
echo ==================================
echo    情绪画布 - 一键部署工具
echo ==================================
echo.

:: 设置颜色
setlocal enabledelayedexpansion
color 0a

:: 检查Git安装
git --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ 请先安装Git: https://git-scm.com/download/win
    pause
    exit /b 1
)

:: 设置变量
set REPO_URL=https://github.com/AnShiyi-1/qxhb.git
set BRANCH=main

:: 开始部署流程
echo 🚀 开始部署流程...

:: 构建项目
echo 📦 构建项目...
call npm run build
if %errorlevel% neq 0 (
    echo ❌ 构建失败，请检查项目
    pause
    exit /b 1
)

:: 初始化Git仓库（如果不存在）
if not exist .git (
    echo 🔄 初始化Git仓库...
    git init
    git config --global user.email "deploy@example.com"
    git config --global user.name "Deploy Bot"
    git remote add origin %REPO_URL%
)

:: 创建gh-pages分支用于GitHub Pages
echo 🌐 准备GitHub Pages...
git checkout -b gh-pages 2>nul || git checkout gh-pages

:: 添加构建文件
echo 📋 添加构建文件...
git add dist/ -f
git add index.html -f
git add package.json -f
git add README.md -f

:: 提交更改
echo 💾 提交更改...
git commit -m "Deploy emotion canvas to GitHub Pages" --allow-empty

:: 推送到GitHub
echo 🎯 推送到GitHub...
git push -u origin gh-pages --force

:: 返回主分支
git checkout main 2>nul || git checkout -b main

echo.
echo ✅ 部署完成！
echo.
echo 🌐 在线地址: https://AnShiyi-1.github.io/qxhb
pause