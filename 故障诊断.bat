@echo off
:: 故障诊断脚本，防止闪退
title 情绪画布 - 故障诊断
color 0E

:diagnostic_menu
cls
echo ╔═══════════════════════════════════════╗
echo ║        情绪画布 - 故障诊断             ║
echo ╚═══════════════════════════════════════╝
echo.
echo 请选择诊断项目：
echo.
echo 1. 检查Node.js环境
echo 2. 检查项目依赖
echo 3. 检查端口占用
echo 4. 检查文件完整性
echo 5. 一键修复常见问题
echo 6. 返回主菜单
echo.

set /p diag_choice=请输入选项（1-6）: 

if "%diag_choice%"=="1" goto check_node
if "%diag_choice%"=="2" goto check_deps
if "%diag_choice%"=="3" goto check_ports
if "%diag_choice%"=="4" goto check_files
if "%diag_choice%"=="5" goto auto_fix
if "%diag_choice%"=="6" goto exit_diag

echo 无效选择，请重新输入
timeout /t 2 >nul
goto diagnostic_menu

:check_node
cls
echo ╔═══════════════════════════════════════╗
echo ║        Node.js环境检查                ║
echo ╚═══════════════════════════════════════╝
echo.

echo 检查Node.js版本...
node --version 2>nul
if errorlevel 1 (
    echo ❌ Node.js未安装或未添加到PATH
    echo.
    echo 解决方案：
    echo 1. 访问 https://nodejs.org/
    echo 2. 下载LTS版本
    echo 3. 安装时勾选"Add to PATH"
    echo.
    echo 安装完成后重启此脚本
) else (
    echo ✅ Node.js已安装：
    node --version
    echo.
    echo ✅ npm版本：
    npm --version
)

echo.
pause
goto diagnostic_menu

:check_deps
cls
echo ╔═══════════════════════════════════════╗
echo ║        项目依赖检查                   ║
echo ╚═══════════════════════════════════════╝
echo.

cd /d "%~dp0"

if exist "node_modules" (
    echo ✅ node_modules文件夹存在
    echo.
    echo 检查package.json...
    if exist "package.json" (
        echo ✅ package.json存在
        echo.
        echo 主要依赖状态：
        if exist "node_modules\vue" echo ✅ Vue.js已安装
        if exist "node_modules\express" echo ✅ Express已安装
        if exist "node_modules\axios" echo ✅ Axios已安装
    ) else (
        echo ❌ package.json缺失！
    )
) else (
    echo ❌ node_modules文件夹不存在
    echo.
    echo 解决方案：
    echo 运行：npm install
)

echo.
pause
goto diagnostic_menu

:check_ports
cls
echo ╔═══════════════════════════════════════╗
echo ║        端口占用检查                   ║
echo ╚═══════════════════════════════════════╝
echo.

echo 检查常用端口占用情况：
echo.
echo 端口3000（后端）：
netstat -ano | findstr ":3000"
if errorlevel 1 (
    echo ✅ 端口3000空闲
) else (
    echo ❌ 端口3000被占用
)

echo.
echo 端口5173（前端开发）：
netstat -ano | findstr ":5173"
if errorlevel 1 (
    echo ✅ 端口5173空闲
) else (
    echo ❌ 端口5173被占用
)

echo.
echo 端口4173（前端预览）：
netstat -ano | findstr ":4173"
if errorlevel 1 (
    echo ✅ 端口4173空闲
) else (
    echo ❌ 端口4173被占用
)

echo.
echo 解决方案：
echo - 如果被占用，可以关闭占用程序
echo - 或修改配置文件使用其他端口
pause
goto diagnostic_menu

:check_files
cls
echo ╔═══════════════════════════════════════╗
echo ║        文件完整性检查                ║
echo ╚═══════════════════════════════════════╝
echo.

cd /d "%~dp0"

echo 检查关键文件：
echo.

:: 检查项目文件
if exist "package.json" (echo ✅ package.json) else (echo ❌ package.json缺失)
if exist "vite.config.js" (echo ✅ vite.config.js) else (echo ❌ vite.config.js缺失)
if exist "server\index.js" (echo ✅ server/index.js) else (echo ❌ server/index.js缺失)
if exist "src\main.js" (echo ✅ src/main.js) else (echo ❌ src/main.js缺失)

:: 检查配置文件
if exist ".env" (echo ✅ .env) else (echo ⚠️ .env不存在，将使用默认配置)
if exist "vercel.json" (echo ✅ vercel.json) else (echo ⚠️ vercel.json不存在)

:: 检查构建文件
if exist "dist" (echo ✅ dist文件夹存在) else (echo ⚠️ dist文件夹不存在，需要构建)

echo.
pause
goto diagnostic_menu

:auto_fix
cls
echo ╔═══════════════════════════════════════╗
echo ║        一键修复常见问题              ║
echo ╚═══════════════════════════════════════╝
echo.

cd /d "%~dp0"

echo 正在执行自动修复...
echo.

:: 1. 重新安装依赖
echo 1. 重新安装项目依赖...
if exist "node_modules" (
    echo 删除旧依赖...
    rmdir /s /q node_modules
)
if exist "package-lock.json" (
    echo 删除package-lock.json...
    del package-lock.json
)
echo 安装新依赖...
call npm install

:: 2. 重新构建
echo.
echo 2. 重新构建项目...
call npm run build

:: 3. 创建缺失的文件
echo.
echo 3. 检查并创建缺失文件...

if not exist ".env" (
    echo 创建.env文件...
    echo NODE_ENV=development > .env
    echo VITE_API_BASE_URL=http://localhost:3000/api >> .env
)

echo.
echo ✅ 自动修复完成！
echo 请重新运行启动脚本
pause
goto diagnostic_menu

:exit_diag
exit