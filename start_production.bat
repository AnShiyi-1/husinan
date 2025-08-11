@echo off
echo 正在启动绘画软件（生产模式）...
echo.

:: 检查Node.js是否安装
node --version >nul 2>&1
if errorlevel 1 (
    echo 错误: 请先安装Node.js！
    echo 下载地址: https://nodejs.org/
    pause
    exit /b 1
)

:: 设置环境变量
set NODE_ENV=production
set PORT=3000

:: 启动服务器
echo 启动服务器...
start cmd /k "cd /d %~dp0 && node server/index.js"

:: 等待1秒
timeout /t 1 /nobreak >nul

echo.
echo 服务器已启动！
echo 访问地址: http://localhost:3000
echo.
echo 按任意键打开浏览器...
pause >nul

:: 打开浏览器
start http://localhost:3000