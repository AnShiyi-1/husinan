@echo off
:: 防止闪退的关键设置
setlocal enabledelayedexpansion

:: 设置窗口标题和颜色
title 情绪画布 - 一键启动
color 0A

:: 显示启动信息
echo ╔═══════════════════════════════════════╗
echo ║        情绪画布 - 一键启动             ║
echo ╚═══════════════════════════════════════╝
echo.
echo 正在检查环境...

:: 检查Node.js
node --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Node.js未安装！
    echo.
    echo 请按以下步骤操作：
    echo 1. 访问 https://nodejs.org/
    echo 2. 下载并安装Node.js
    echo 3. 安装完成后重新运行此脚本
    echo.
    echo 按任意键退出...
    pause >nul
    exit /b 1
)

echo ✅ Node.js已安装

:: 进入项目目录
cd /d "%~dp0"

:: 检查依赖
if not exist "node_modules" (
    echo 正在安装依赖...
    call npm install
    if errorlevel 1 (
        echo ❌ 依赖安装失败！
        echo 请检查网络连接后重试
        pause
        exit /b 1
    )
)

echo ✅ 依赖已就绪

:: 检查端口占用
echo 正在检查端口...
netstat -ano | findstr ":3000" >nul
if %errorlevel%==0 (
    echo ⚠️ 端口3000已被占用，将使用其他端口
)

:: 启动后端服务
echo.
echo 正在启动后端服务器...
start cmd /k "title 后端服务器 && cd /d "%~dp0" && npm run server"
timeout /t 3 >nul

:: 启动前端开发服务器
echo 正在启动前端开发服务器...
start cmd /k "title 前端开发服务器 && cd /d "%~dp0" && npm run dev"

:: 等待服务启动
timeout /t 2 >nul

:: 打开浏览器
echo.
echo 🎉 启动成功！
echo 正在打开浏览器...
timeout /t 1 >nul
start http://localhost:5173
start http://localhost:3000/api/health

echo.
echo ╔═══════════════════════════════════════╗
echo ║           启动完成！                  ║
echo ╠═══════════════════════════════════════╣
echo ║  前端地址：http://localhost:5173      ║
echo ║  后端地址：http://localhost:3000      ║
echo ║  API测试：http://localhost:3000/api/health ║
echo ╚═══════════════════════════════════════╝
echo.
echo 按任意键关闭此窗口（不会影响已启动的服务）...
pause >nul