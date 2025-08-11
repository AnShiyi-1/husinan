@echo off
title 情绪画布 - Vercel前后端一键部署
color 0A
chcp 65001 >nul

:: 防止闪退设置
setlocal enabledelayedexpansion

:: 创建日志文件
set log_file=%~dp0vercel_deploy_log.txt
echo [%date% %time%] 开始Vercel部署 >> "%log_file%"

:: 显示欢迎信息
cls
echo ╔═══════════════════════════════════════╗
echo ║     情绪画布 - Vercel前后端一键部署     ║
echo ╚═══════════════════════════════════════╝
echo.
echo 正在检查部署环境...
echo.

:: 检查Node.js
node --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Node.js未安装！
    echo 请访问 https://nodejs.org/ 下载安装Node.js
    pause
    exit /b 1
)

echo ✅ Node.js已安装：
node --version
echo.

:: 检查Vercel CLI
where vercel >nul 2>&1
if errorlevel 1 (
    echo 正在安装Vercel CLI...
    call npm install -g vercel
    if errorlevel 1 (
        echo ❌ Vercel CLI安装失败！
        pause
        exit /b 1
    )
)

echo ✅ Vercel CLI已就绪

:: 进入项目目录
cd /d "%~dp0"

echo.
echo ╔═══════════════════════════════════════╗
echo ║         第一步：构建项目              ║
echo ╚═══════════════════════════════════════╝
echo.

:: 安装依赖
echo 正在安装项目依赖...
call npm install
if errorlevel 1 (
    echo ❌ 依赖安装失败！
    pause
    exit /b 1
)

:: 构建前端
echo 正在构建前端项目...
call npm run build
if errorlevel 1 (
    echo ❌ 前端构建失败！
    pause
    exit /b 1
)

echo ✅ 项目构建完成

:: 创建Vercel配置文件
echo.
echo ╔═══════════════════════════════════════╗
echo ║         第二步：配置Vercel            ║
echo ╚═══════════════════════════════════════╝
echo.

:: 创建优化的vercel.json
echo 正在创建Vercel配置文件...
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
echo       "src": "/(.*)",
echo       "dest": "/dist/$1"
echo     },
echo     {
echo       "src": "/",
echo       "dest": "/dist/index.html"
echo     }
echo   ],
echo   "env": {
echo     "NODE_ENV": "production"
echo   }
echo }
) > vercel.json

echo ✅ Vercel配置文件已创建

:: 创建环境变量文件
echo.
echo 正在配置环境变量...
if not exist ".env.production" (
    echo NODE_ENV=production > .env.production
    echo VITE_API_BASE_URL=/api >> .env.production
    echo JWT_SECRET=your_jwt_secret_key_here >> .env.production
    echo SUPABASE_URL=your_supabase_url >> .env.production
    echo SUPABASE_ANON_KEY=your_supabase_anon_key >> .env.production
)

echo ✅ 环境变量已配置

:: 启动Vercel部署
echo.
echo ╔═══════════════════════════════════════╗
echo ║         第三步：部署到Vercel          ║
echo ╚═══════════════════════════════════════╝
echo.
echo 即将开始Vercel部署流程...
echo.
echo 请按以下步骤操作：
echo 1. 按回车键开始部署
echo 2. 登录Vercel账号（或注册）
echo 3. 选择部署设置
echo 4. 等待部署完成
pause

echo.
echo 🚀 正在启动Vercel部署...
echo 请在新打开的窗口中完成部署...
start cmd /k "cd /d "%~dp0" && echo 正在部署到Vercel... && vercel --prod"

echo.
echo ╔═══════════════════════════════════════╗
echo ║         部署完成后的操作              ║
echo ╚═══════════════════════════════════════╝
echo.
echo 部署完成后：
echo.
echo 1. 复制生成的域名（如：https://your-app.vercel.app）
echo 2. 更新前端API配置：
echo    - 编辑 .env.production 文件
necho    - 修改 VITE_API_BASE_URL 为你的完整域名 + /api
echo    - 例如：https://your-app.vercel.app/api
3. 重新部署一次使配置生效
echo.
echo 按任意键查看部署验证说明...
pause

:: 创建部署验证脚本
echo.
echo 正在创建部署验证工具...
(
echo @echo off
echo title 验证Vercel部署
echo color 0A
echo.
echo ╔═══════════════════════════════════════╗
echo echo ║        验证Vercel部署状态             ║
echo echo ╚═══════════════════════════════════════╝
echo.
echo 请输入你的Vercel域名：
echo set /p domain=域名: 
echo.
echo if "%%domain%%"=="" (
echo    echo 域名不能为空！
echo    pause
echo    exit /b 1
echo )
echo.
echo if not "%%domain:~0,8%%"=="https://" (
echo    set domain=https://%%domain%%
echo )
echo.
echo echo 正在测试前端...
echo start %%domain%%
echo.
echo echo 正在测试后端API...
echo start %%domain%%/api/health
echo.
echo echo 正在测试用户API...
echo start %%domain%%/api/auth/test
echo.
echo echo 测试链接已打开，请检查浏览器！
echo pause
) > 验证部署.bat

echo ✅ 部署验证工具已创建：验证部署.bat

echo.
echo 🎉 所有步骤已完成！
echo.
echo 下一步：
echo 1. 完成Vercel部署
2. 运行 验证部署.bat 测试部署结果
echo 3. 享受你的在线情绪画布！
pause