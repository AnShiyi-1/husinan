@echo off
title 部署状态测试
color 0A

echo ╔═══════════════════════════════════════╗
echo ║        部署状态检查工具               ║
echo ╚═══════════════════════════════════════╝
echo.

:: 测试本地服务
echo 测试本地服务...
start http://localhost:3000
start http://localhost:3000/api/health

:: 测试部署状态
echo.
echo 如果你已经部署到Vercel，请输入你的域名进行测试
echo 例如：https://your-project.vercel.app
set /p deployed_url=域名（留空跳过）: 

if not "%deployed_url%"=="" (
    if not "%deployed_url:~0,8%"=="https://" (
        set deployed_url=https://%deployed_url%
    )
    echo.
    echo 正在测试部署...
    start %deployed_url%
    start %deployed_url%/api/health
)

echo.
echo ✅ 测试链接已打开，请检查浏览器！
pause