@echo off
chcp 65001 >nul
title 情绪画布 - 稳定启动器
color 0A

:: 防止闪退的关键设置
setlocal enabledelayedexpansion

:: 创建日志文件
set log_file=%~dp0launcher_log.txt
echo [%date% %time%] 启动器启动 >> "%log_file%"

:: 检查是否以管理员身份运行
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo 警告：未以管理员身份运行，某些功能可能受限
    echo [%date% %time%] 非管理员模式 >> "%log_file%"
)

:main_menu
cls
echo ╔═══════════════════════════════════════╗
echo ║        情绪画布 - 稳定启动器           ║
echo ╚═══════════════════════════════════════╝
echo.
echo 请选择操作：
echo.
echo 1. 启动本地开发环境（前后端）
echo 2. 启动生产环境
necho 3. 部署到互联网
necho 4. 测试部署状态
echo 5. 查看日志
necho 6. 退出
echo.

set /p choice=请输入选项（1-6）: 

if "%choice%"=="1" goto start_dev
if "%choice%"=="2" goto start_production
if "%choice%"=="3" goto deploy
if "%choice%"=="4" goto test_status
if "%choice%"=="5" goto view_logs
if "%choice%"=="6" goto exit_app

echo 无效选择，请重新输入
timeout /t 2 >nul
goto main_menu

:start_dev
echo.
echo 正在启动开发环境...
echo [%date% %time%] 启动开发环境 >> "%log_file%"

cd /d "%~dp0"

:: 检查Node.js
node --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Node.js未安装！
    echo 请访问 https://nodejs.org/ 下载安装
    pause
    goto main_menu
)

echo ✅ Node.js已安装

:: 检查依赖
if not exist "node_modules" (
    echo 正在安装依赖...
    call npm install
    if errorlevel 1 (
        echo 依赖安装失败！
        pause
        goto main_menu
    )
)

echo ✅ 依赖已就绪

:: 启动后端服务
echo 正在启动后端服务器...
start cmd /k "title 后端服务器 && cd /d "%~dp0" && npm run server"
timeout /t 3 >nul

:: 启动前端开发服务器
echo 正在启动前端开发服务器...
start cmd /k "title 前端开发服务器 && cd /d "%~dp0" && npm run dev"

echo.
echo 🎉 开发环境已启动！
echo 前端：http://localhost:5173
echo 后端：http://localhost:3000
pause
goto main_menu

:start_production
echo.
echo 正在启动生产环境...
echo [%date% %time%] 启动生产环境 >> "%log_file%"

cd /d "%~dp0"

:: 检查构建文件
if not exist "dist" (
    echo 正在构建项目...
    call npm run build
    if errorlevel 1 (
        echo 构建失败！
        pause
        goto main_menu
    )
)

echo ✅ 项目已构建

:: 启动生产服务器
echo 正在启动生产服务器...
start cmd /k "title 生产服务器 && cd /d "%~dp0" && npm run preview"

echo.
echo 🎉 生产环境已启动！
echo 访问地址：http://localhost:4173
pause
goto main_menu

:deploy
echo.
echo 正在检查部署环境...
echo [%date% %time%] 开始部署 >> "%log_file%"

cd /d "%~dp0"

:: 检查Vercel CLI
where vercel >nul 2>&1
if errorlevel 1 (
    echo 正在安装Vercel CLI...
    call npm install -g vercel
)

echo.
echo 🚀 正在启动部署流程...
echo 请在新打开的窗口中完成Vercel部署
start cmd /k "title Vercel部署 && cd /d "%~dp0" && vercel --prod"

pause
goto main_menu

:test_status
echo.
echo 正在测试部署状态...
echo [%date% %time%] 测试部署状态 >> "%log_file%"

:: 测试本地服务
echo.
echo 测试本地服务：
echo 前端：http://localhost:5173
echo 后端：http://localhost:3000/api/health
start http://localhost:5173
start http://localhost:3000/api/health

:: 询问已部署的域名
set /p deployed_url=请输入已部署的域名（如：https://your-app.vercel.app）： 

if not "%deployed_url%"=="" (
    if not "%deployed_url:~0,8%"=="https://" (
        set deployed_url=https://%deployed_url%
    )
    echo.
    echo 测试部署域名：
    echo 前端：%deployed_url%
    echo 后端：%deployed_url%/api/health
    start %deployed_url%
    start %deployed_url%/api/health
)

pause
goto main_menu

:view_logs
echo.
echo ╔═══════════════════════════════════════╗
echo ║            运行日志                   ║
echo ╚═══════════════════════════════════════╝
echo.

if exist "%log_file%" (
    type "%log_file%"
) else (
    echo 暂无日志
)

echo.
echo 按任意键返回主菜单...
pause >nul
goto main_menu

:exit_app
echo.
echo 感谢使用情绪画布！
echo [%date% %time%] 退出启动器 >> "%log_file%"
timeout /t 2 >nul
exit