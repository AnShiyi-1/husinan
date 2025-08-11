@echo off
title 情绪画布离线部署工具
color 0B

echo ╔═══════════════════════════════════════╗
echo ║        情绪画布离线部署工具           ║
echo ╚═══════════════════════════════════════╝
echo.

:: 检查基础环境
echo 正在检查部署环境...

:: 检查Node.js
node --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Node.js未安装
    echo 请访问: https://nodejs.org/zh-cn/
    echo 下载并安装Node.js后再试
    pause
    exit /b 1
)

echo ✅ Node.js已安装

:: 检查npm
npm --version >nul 2>&1
if errorlevel 1 (
    echo ❌ npm未安装
    pause
    exit /b 1
)

echo ✅ npm已安装

:: 进入项目目录
cd /d "%~dp0"

:: 创建本地服务器启动脚本
echo.
echo 正在创建本地服务器启动脚本...

:: 创建start_server.js文件
echo const express = require('express'); > start_server.js
echo const path = require('path'); >> start_server.js
echo const app = express(); >> start_server.js
echo const PORT = process.env.PORT || 3000; >> start_server.js
echo. >> start_server.js
echo app.use(express.static(path.join(__dirname, 'dist'))); >> start_server.js
echo app.use(express.json()); >> start_server.js
echo. >> start_server.js
echo // 简单的API路由 >> start_server.js
echo app.post('/api/auth/login', (req, res) =^> { >> start_server.js
echo   res.json({ success: true, token: 'demo-token', user: { username: 'demo' } }); >> start_server.js
echo }); >> start_server.js
echo. >> start_server.js
echo app.get('*', (req, res) =^> { >> start_server.js
echo   res.sendFile(path.join(__dirname, 'dist', 'index.html')); >> start_server.js
echo }); >> start_server.js
echo. >> start_server.js
echo app.listen(PORT, () =^> { >> start_server.js
echo   console.log(\`服务器运行在 http://localhost:${PORT}\`); >> start_server.js
echo   console.log('按 Ctrl+C 停止服务器'); >> start_server.js
echo }); >> start_server.js

echo ✅ 服务器脚本已创建

:: 检查构建文件
if not exist "dist" (
    echo.
    echo ❌ 构建文件不存在，正在构建...
    call npm run build
    if errorlevel 1 (
        echo 构建失败！请手动运行: npm run build
        pause
        exit /b 1
    )
)

echo ✅ 构建文件已就绪

:: 创建启动菜单
echo.
echo ╔═══════════════════════════════════════╗
echo ║          选择部署方式                 ║
echo ╚═══════════════════════════════════════╝
echo.
echo 1. 本地服务器（推荐测试用）
echo 2. 打开部署指南
necho 3. 创建便携式版本
necho 4. 退出

echo.
set /p choice=请选择(1-4): 

if "%choice%"=="1" goto local_server
if "%choice%"=="2" goto open_guide
if "%choice%"=="3" goto portable
if "%choice%"=="4" goto exit

goto local_server

:local_server
echo.
echo 正在启动本地服务器...
echo 服务器地址: http://localhost:3000
echo 按 Ctrl+C 停止服务器
echo.
timeout /t 1 >nul
node start_server.js
pause
goto exit

:open_guide
start notepad.exe "DEPLOY_GUIDE.md"
goto exit

:portable
echo.
echo 正在创建便携式版本...
echo 将创建包含所有依赖的独立文件夹...

:: 创建portable文件夹
if not exist "portable" mkdir portable
xcopy /E /I dist portable\dist
xcopy /E /I server portable\server
copy package.json portable\
copy package-lock.json portable\
copy start_server.js portable\

echo ✅ 便携式版本已创建到 portable 文件夹
echo 可以将整个portable文件夹复制到其他电脑直接运行
echo 运行方式: node start_server.js
pause

:exit
echo 部署工具已关闭