@echo off
chcp 65001 >nul
echo === 修复部署问题 ===
echo.

:: 检查Node.js
node --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Node.js未安装，请先安装Node.js
    pause
    exit /b 1
)

echo ✅ Node.js已安装

:: 检查Vercel CLI
vercel --version >nul 2>&1
if errorlevel 1 (
    echo 📦 正在安装Vercel CLI...
    npm install -g vercel
)

echo ✅ Vercel CLI已就绪

:: 安装依赖
echo 📦 安装项目依赖...
npm install

:: 构建项目
echo 🔨 构建项目...
npm run build

:: 部署
echo 🚀 开始部署...
echo.
echo 请选择：
echo 1. 自动部署到Vercel
vercel --prod

echo.
echo ✅ 部署完成！
pause