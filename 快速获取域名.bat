@echo off
color 0a
title 获取Vercel域名
echo.
echo ╔═══════════════════════════════════════╗
echo ║        正在部署并获取域名...          ║
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

:: 安装依赖
echo 📦 安装依赖...
npm install >nul 2>&1

:: 构建项目
echo 🔨 构建项目...
npm run build >nul 2>&1

:: 创建vercel配置
echo ⚙️ 创建Vercel配置...
(
echo {
echo   "version": 2,
echo   "builds": [
echo     {
echo       "src": "server/index.js",
echo       "use": "@vercel/node"
echo     }
echo   ],
echo   "routes": [
echo     {
echo       "src": "/api/(.*)",
echo       "dest": "server/index.js"
echo     },
echo     {
echo       "src": "/(.*)",
echo       "dest": "/dist/$1"
echo     }
echo   ]
echo }
) > vercel.json

echo 🚀 准备部署...
echo.
echo 📋 请按以下步骤操作：
echo 1. 在弹出的窗口中选择项目范围
2. 选择默认设置（直接按回车）
3. 等待部署完成
4. 复制生成的域名
echo.
echo 🎯 部署完成后，你会获得类似：
echo    https://your-app-xxxx.vercel.app
pause

:: 启动部署
vercel --prod