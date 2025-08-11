@echo off
echo 正在启动绘画软件服务器...
echo.

:: 启动后端服务器
echo 启动后端服务器 (端口3000)...
start cmd /k "cd /d %~dp0 && node server/index.js"

:: 等待2秒确保后端启动
timeout /t 2 /nobreak >nul

:: 启动前端开发服务器
echo 启动前端服务器 (端口5173)...
start cmd /k "cd /d %~dp0 && npx vite --host"

echo.
echo 服务器启动完成！
echo 后端: http://localhost:3000
echo 前端: http://localhost:5173
echo.
echo 按任意键打开浏览器访问...
pause >nul

:: 自动打开浏览器
start http://localhost:5173

pause