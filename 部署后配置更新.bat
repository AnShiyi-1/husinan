@echo off
title 部署后配置更新
color 0B
chcp 65001 >nul

echo ╔═══════════════════════════════════════╗
echo ║        部署后配置更新工具             ║
echo ╚═══════════════════════════════════════╝
echo.

:: 获取部署域名
echo 请输入你的Vercel部署域名：
echo 示例：https://your-app-name.vercel.app
set /p deployed_domain=域名: 

if "%deployed_domain%"=="" (
    echo 域名不能为空！
    pause
    exit /b 1
)

:: 确保URL格式正确
if not "%deployed_domain:~0,8%"=="https://" (
    set deployed_domain=https://%deployed_domain%
)

:: 移除末尾的斜杠
if "%deployed_domain:~-1%"=="/" (
    set deployed_domain=%deployed_domain:~0,-1%
)

echo.
echo 正在更新配置文件...

:: 更新生产环境变量
echo NODE_ENV=production > .env.production
echo VITE_API_BASE_URL=%deployed_domain%/api >> .env.production

:: 备份原vercel.json
copy vercel.json vercel.json.backup >nul

:: 创建新的vercel.json（使用绝对路径）
(
echo {
echo   "version": 2,
echo   "builds": [
echo     {
echo       "src": "server/index.js",
echo       "use": "@vercel/node",
echo       "config": {
echo         "maxLambdaSize": "50mb"
echo       }
echo     }
echo   ],
echo   "routes": [
echo     {
echo       "src": "/api/(.*)",
echo       "dest": "server/index.js"
echo     },
echo     {
echo       "src": "/assets/(.*)",
echo       "dest": "/dist/assets/$1"
echo     },
echo     {
echo       "src": "/(.*\\.(js|css|png|jpg|jpeg|gif|svg|ico|woff|woff2|ttf|eot))",
echo       "dest": "/dist/$1"
echo     },
echo     {
echo       "src": "/(.*)",
echo       "dest": "/dist/index.html"
echo     }
echo   ],
echo   "env": {
echo     "NODE_ENV": "production"
echo   },
echo   "functions": {
echo     "server/index.js": {
echo       "runtime": "nodejs18.x"
echo     }
echo   }
echo }
) > vercel.json

echo.
echo ✅ 配置文件已更新！
echo.
echo 正在重新构建项目...
call npm run build
if errorlevel 1 (
    echo ❌ 构建失败！
    pause
    exit /b 1
)

echo.
echo 🎉 配置更新完成！
echo.
echo 更新内容：
echo - API基础URL: %deployed_domain%/api
echo - 生产环境变量: .env.production
echo - Vercel配置: vercel.json

echo.
echo 下一步：
echo 1. 重新运行一键部署Vercel前后端.bat
2. 或手动执行：vercel --prod
pause