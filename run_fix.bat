@echo off
echo 正在修复情绪画布数据库...
echo.

REM 检查是否安装了curl
where curl >nul 2>nul
if %errorlevel% neq 0 (
    echo 请手动访问 Supabase 控制台执行修复脚本
    echo 打开: https://app.supabase.com
    echo.
    pause
    exit /b
)

echo 请按照以下步骤操作：
echo 1. 打开 Supabase 控制台: https://app.supabase.com
echo 2. 选择你的项目
echo 3. 打开 SQL Editor
echo 4. 执行 database_fix_complete.sql 中的SQL
echo.
echo 完成后按任意键继续...
pause

echo.
echo 正在重启服务器...
taskkill /f /im node.exe 2>nul
timeout /t 2 /nobreak >nul
echo.
echo 请重新启动服务器：
echo npm run server
echo.
pause