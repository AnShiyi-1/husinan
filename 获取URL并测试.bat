@echo off
chcp 65001 >nul
title 获取可访问的URL地址

echo 正在获取您的绘画应用URL地址...
echo.

:: 获取最新的Ready状态URL
for /f "tokens=2" %%a in ('vercel list ^| findstr /c:"Ready" ^| findstr /c:"vercel.app"') do (
    set "URL=%%a"
    goto :found
)

:found
echo.
echo ✅ 您的绘画应用URL地址：
echo %URL%
echo.

:: 测试URL是否可访问
echo 正在测试URL是否可访问...
start %URL%

:: 显示其他可用的Ready状态URL
echo.
echo 🔗 其他可用的备用地址：
vercel list | findstr /c:"Ready" | findstr /c:"vercel.app"

echo.
echo 📱 现在您可以：
echo 1. 复制上面的URL到浏览器访问
echo 2. 手机浏览器直接访问
echo 3. 分享给朋友使用

echo.
pause