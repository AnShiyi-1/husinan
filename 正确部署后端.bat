@echo off
title 情绪画布后端部署工具
color 0E

echo ╔═══════════════════════════════════════╗
echo ║        情绪画布后端部署工具           ║
echo ╚═══════════════════════════════════════╝
echo.

:: 检查环境
echo 正在检查部署环境...

:: 检查Node.js
node --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Node.js未安装
    echo 请先安装Node.js: https://nodejs.org/
    pause
    exit /b 1
)

echo ✅ Node.js已安装

:: 进入项目目录
cd /d "%~dp0"

:: 构建项目
echo.
echo 正在构建项目...
call npm run build
if errorlevel 1 (
    echo 构建失败！
    pause
    exit /b 1
)

echo ✅ 项目构建完成

:: 检查Vercel CLI
where vercel >nul 2>&1
if errorlevel 1 (
    echo 正在安装Vercel CLI...
    call npm install -g vercel
)

echo ✅ Vercel CLI已就绪

:: 创建正确的Vercel配置
echo.
echo 正在配置Vercel部署...

:: 创建新的vercel.json
echo { > vercel.json
echo   "version": 2, >> vercel.json
echo   "builds": [ >> vercel.json
echo     { >> vercel.json
echo       "src": "server/index.js", >> vercel.json
echo       "use": "@vercel/node" >> vercel.json
echo     } >> vercel.json
echo   ], >> vercel.json
echo   "routes": [ >> vercel.json
echo     { >> vercel.json
echo       "src": "/api/(.*)", >> vercel.json
echo       "dest": "server/index.js" >> vercel.json
echo     }, >> vercel.json
echo     { >> vercel.json
echo       "src": "/(.*)", >> vercel.json
echo       "dest": "dist/$1" >> vercel.json
echo     }, >> vercel.json
echo     { >> vercel.json
echo       "src": "/", >> vercel.json
echo       "dest": "dist/index.html" >> vercel.json
echo     } >> vercel.json
echo   ] >> vercel.json
echo } >> vercel.json

echo ✅ Vercel配置已创建

:: 启动Vercel部署
echo.
echo ╔═══════════════════════════════════════╗
echo ║        开始Vercel部署流程             ║
echo ╚═══════════════════════════════════════╝
echo.
echo 请按以下步骤操作：
echo 1. 按回车键开始部署
pause >nul

:: 启动Vercel部署
echo.
echo 正在启动Vercel部署...
echo 请在新打开的窗口中：
echo 1. 登录Vercel账号（或注册）
echo 2. 选择当前项目
necho 3. 确认部署设置
start cmd /k "cd /d "%~dp0" && vercel --prod"

echo.
echo 🎉 部署已启动！
echo 完成后你将获得类似：https://your-project.vercel.app 的域名
echo.
echo 部署完成后：
echo 1. 复制生成的域名
echo 2. 在 src/services/api.js 中替换 API_BASE_URL
echo 3. 重新构建并部署前端
pause