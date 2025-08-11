@echo off
echo 正在准备部署到Vercel...
echo.

:: 检查Node.js和npm
node --version >nul 2>&1
if errorlevel 1 (
    echo 错误: 请先安装Node.js！
    echo 下载地址: https://nodejs.org/
    pause
    exit /b 1
)

:: 检查Vercel CLI
vercel --version >nul 2>&1
if errorlevel 1 (
    echo 正在安装Vercel CLI...
    npm install -g vercel
)

:: 构建项目
echo 正在构建项目...
call npm run build
if errorlevel 1 (
    echo 构建失败，请检查错误！
    pause
    exit /b 1
)

:: 部署到Vercel
echo.
echo 准备完成！
echo 正在打开Vercel部署界面...
echo.
echo 请选择：
echo 1. 登录Vercel账号
echo 2. 选择部署项目
echo 3. 完成部署

echo.
echo 按任意键开始部署...
pause >nul

:: 启动Vercel部署
vercel --prod

echo.
echo 🎉 部署完成！
echo 访问你的域名查看效果
pause