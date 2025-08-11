@echo off
chcp 65001
title ✅ 部署验证工具
cls
echo.
echo ======================================
echo     🔍 部署状态验证工具
echo ======================================
echo.

:: 检查本地构建
echo 🔍 检查本地构建...
if exist "dist\index.html" (
    echo ✅ 前端构建成功
) else (
    echo ❌ 前端未构建，请先运行：npm run build
    pause
    exit /b
)

if exist "server\index.js" (
    echo ✅ 后端服务文件存在
) else (
    echo ❌ 后端文件缺失
    pause
    exit /b
)

:: 检查Vercel配置
echo.
echo 🔍 检查Vercel配置...
if exist "vercel.json" (
    echo ✅ Vercel配置文件存在
) else (
    echo ❌ Vercel配置文件缺失
    pause
    exit /b
)

:: 检查环境变量
echo.
echo 🔍 检查环境变量...
if exist ".env" (
    echo ✅ 环境变量文件存在
) else (
    echo ⚠️  环境变量文件缺失，将使用默认配置
)

:: 检查依赖
echo.
echo 🔍 检查项目依赖...
if exist "node_modules" (
    echo ✅ 依赖已安装
) else (
    echo ❌ 依赖未安装，请先运行：npm install
    pause
    exit /b
)

:: 显示项目信息
echo.
echo ======================================
echo     📊 项目信息
echo ======================================
echo 📁 项目路径：%cd%
echo 📦 项目名称：情绪画布
echo 🎯 框架：Vue3 + Express
echo ☁️  部署平台：Vercel（免费）
echo.
echo ✅ 所有检查通过！
echo.
echo 🚀 现在可以运行：免费部署到网上.bat
echo 💡 开始免费部署到互联网！
echo.
pause