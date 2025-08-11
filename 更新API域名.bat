@echo off
title 更新API域名配置
color 0B

echo ╔═══════════════════════════════════════╗
echo ║        更新API域名配置工具            ║
echo ╚═══════════════════════════════════════╝
echo.

:: 获取用户输入
echo 请输入你的后端域名（例如：https://your-app.vercel.app）
set /p backend_url=后端域名: 

if "%backend_url%"=="" (
    echo 域名不能为空！
    pause
    exit /b 1
)

:: 确保URL格式正确
if not "%backend_url:~0,8%"=="https://" (
    set backend_url=https://%backend_url%
)

:: 更新环境变量文件
echo VITE_API_BASE_URL=%backend_url%/api > .env.production
echo NODE_ENV=production >> .env.production

echo.
echo ✅ 环境变量已更新！
echo 域名: %backend_url%/api

echo.
echo 正在重新构建项目...
call npm run build
if errorlevel 1 (
    echo 构建失败！
    pause
    exit /b 1
)

echo.
echo 🎉 配置更新完成！
echo 现在可以重新部署前端了
pause