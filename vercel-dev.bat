@echo off
color 0a
title Vercel本地开发
echo.
echo ╔═══════════════════════════════════════╗
echo ║        Vercel本地开发启动器            ║
echo ╚═══════════════════════════════════════╝
echo.

:: 设置编码
chcp 65001 >nul

:: 检查环境
echo ✅ 检查环境...
node --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Node.js未安装
    pause
    exit /b 1
)

:: 清理旧的Vercel配置
echo 🧹 清理旧配置...
if exist ".vercel" rmdir /s /q .vercel

:: 安装依赖
echo 📦 安装依赖...
npm install >nul 2>&1

:: 构建项目
echo 🔨 构建项目...
npm run build >nul 2>&1

:: 初始化Vercel项目
echo ⚙️ 初始化Vercel项目...
echo.
echo 💡 请按以下步骤操作：
echo 1. 选择项目范围：选择你的GitHub账号
echo 2. 项目名称：按回车使用默认
echo 3. 开发框架：选择 "Other"
echo 4. 输出目录：输入 dist
pause

:: 启动本地开发
vercel dev