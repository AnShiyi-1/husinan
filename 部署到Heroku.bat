@echo off
chcp 65001
title 🌸 部署到Heroku - 经典免费平台
cls
echo.
echo ======================================
echo     🌸 Heroku 经典免费部署
     支持Node.js + PostgreSQL
======================================
echo.

:: 1. 环境检查
echo 🔍 检查环境...
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Node.js 未安装
    echo 📥 请访问 https://nodejs.org 下载安装
    pause
    exit /b
)

git --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Git 未安装
    echo 📥 请访问 https://git-scm.com 下载安装
    pause
    exit /b
)

:: 安装Heroku CLI
echo.
echo 📦 安装Heroku CLI...
powershell -Command "Invoke-WebRequest https://cli-assets.heroku.com/install-ubuntu.sh -OutFile heroku-install.sh; bash heroku-install.sh"

:: 2. 创建Heroku配置
echo.
echo 📁 创建Heroku配置...

:: 创建Procfile
echo web: node server/index.js > Procfile

:: 创建app.json
echo { > app.json
echo   "name": "emotion-canvas-backend", >> app.json
echo   "description": "Emotion Canvas Backend API", >> app.json
echo   "repository": "https://github.com/your-username/emotion-canvas-backend", >> app.json
echo   "logo": "https://example.com/logo.png", >> app.json
echo   "keywords": ["node", "express", "api", "canvas"], >> app.json
echo   "image": "heroku/nodejs", >> app.json
echo   "addons": ["heroku-postgresql:hobby-dev"], >> app.json
echo   "env": { >> app.json
echo     "NODE_ENV": "production", >> app.json
echo     "DATABASE_URL": { >> app.json
echo       "required": true >> app.json
echo     } >> app.json
echo   } >> app.json
echo } >> app.json

echo ✅ Heroku配置创建完成

:: 3. 更新package.json
echo.
echo 📦 更新package.json...

echo {
    "name": "emotion-canvas-backend",
    "version": "1.0.0",
    "description": "Emotion Canvas Backend API",
    "main": "server/index.js",
    "scripts": {
        "start": "node server/index.js",
        "dev": "nodemon server/index.js",
        "heroku-postbuild": "echo 'Build completed'"
    },
    "engines": {
        "node": ">=16.0.0"
    },
    "dependencies": {
        "@supabase/supabase-js": "^2.53.0",
        "bcryptjs": "^3.0.2",
        "cors": "^2.8.5",
        "dotenv": "^17.2.1",
        "express": "^4.18.2",
        "jsonwebtoken": "^9.0.2",
        "pg": "^8.11.0"
    }
} > package-heroku.json

echo ✅ Heroku专用package.json创建完成

:: 4. 创建部署脚本
echo.
echo 📝 创建部署脚本...

echo @echo off > deploy-heroku.bat
echo title 🌸 Heroku一键部署 >> deploy-heroku.bat
echo echo 正在准备Heroku部署... >> deploy-heroku.bat
echo echo. >> deploy-heroku.bat
echo echo 步骤1：登录Heroku >> deploy-heroku.bat
echo heroku login >> deploy-heroku.bat
echo echo. >> deploy-heroku.bat
echo echo 步骤2：创建应用 >> deploy-heroku.bat
echo heroku create emotion-canvas-backend >> deploy-heroku.bat
echo echo. >> deploy-heroku.bat
echo echo 步骤3：添加PostgreSQL数据库 >> deploy-heroku.bat
echo heroku addons:create heroku-postgresql:hobby-dev --app emotion-canvas-backend >> deploy-heroku.bat
echo echo. >> deploy-heroku.bat
echo echo 步骤4：部署应用 >> deploy-heroku.bat
echo git add . >> deploy-heroku.bat
echo git commit -m "Initial deployment" >> deploy-heroku.bat
echo git push heroku main >> deploy-heroku.bat
echo echo. >> deploy-heroku.bat
echo echo 步骤5：查看应用 >> deploy-heroku.bat
echo heroku open --app emotion-canvas-backend >> deploy-heroku.bat
echo echo. >> deploy-heroku.bat
echo echo 🎉 部署完成！ >> deploy-heroku.bat
echo echo 访问地址：https://emotion-canvas-backend.herokuapp.com >> deploy-heroku.bat
echo pause >> deploy-heroku.bat

echo ✅ 部署脚本创建完成

:: 5. 创建环境变量模板
echo.
echo 📋 创建环境变量模板...

echo # Heroku 环境变量 > .env.heroku
echo NODE_ENV=production >> .env.heroku
necho PORT=5432 >> .env.heroku
necho DATABASE_URL=postgres://user:pass@host:5432/dbname >> .env.heroku
necho SUPABASE_URL=你的SupabaseURL >> .env.heroku
necho SUPABASE_KEY=你的SupabaseKey >> .env.heroku
necho JWT_SECRET=你的JWT密钥 >> .env.heroku

echo ✅ 环境变量模板创建完成

:: 6. 创建Heroku部署指南
echo.
echo 📖 创建Heroku部署指南...

echo # Heroku 部署指南 > heroku-deploy-guide.txt
echo. >> heroku-deploy-guide.txt
echo ## 准备工作 >> heroku-deploy-guide.txt
echo 1. 安装Heroku CLI >> heroku-deploy-guide.txt
echo 2. 注册Heroku账号 >> heroku-deploy-guide.txt
echo 3. 准备GitHub仓库 >> heroku-deploy-guide.txt
echo. >> heroku-deploy-guide.txt
echo ## 部署步骤 >> heroku-deploy-guide.txt
echo 1. 运行 deploy-heroku.bat >> heroku-deploy-guide.txt
echo 2. 登录Heroku账号 >> heroku-deploy-guide.txt
echo 3. 创建应用 >> heroku-deploy-guide.txt
echo 4. 添加PostgreSQL数据库 >> heroku-deploy-guide.txt
echo 5. 配置环境变量 >> heroku-deploy-guide.txt
echo 6. 部署应用 >> heroku-deploy-guide.txt
echo. >> heroku-deploy-guide.txt
echo ## 免费额度 >> heroku-deploy-guide.txt
echo - 550小时/月运行时间 >> heroku-deploy-guide.txt
echo - 512MB内存 >> heroku-deploy-guide.txt
echo - PostgreSQL免费版 >> heroku-deploy-guide.txt
echo - 自定义域名 >> heroku-deploy-guide.txt
echo. >> heroku-deploy-guide.txt
echo ## 注意事项 >> heroku-deploy-guide.txt
echo - 休眠30分钟后自动停止 >> heroku-deploy-guide.txt
echo - 首次访问需等待启动 >> heroku-deploy-guide.txt
echo - 每月550小时限制 >> heroku-deploy-guide.txt

echo ✅ Heroku部署指南创建完成

:: 7. 创建一键部署按钮
echo.
echo 🔗 创建一键部署按钮...

echo [![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/your-username/emotion-canvas-backend) > deploy-button.md

echo ✅ 一键部署按钮创建完成

:: 8. 最终指导
echo.
echo 🎯 Heroku部署步骤：
echo.
echo 1️⃣  注册Heroku：https://heroku.com
2️⃣  安装Heroku CLI
3️⃣  运行 deploy-heroku.bat
4️⃣  一键部署到云端
5️⃣  获得域名：xxx.herokuapp.com

echo.
echo 📱 最终访问地址：
echo 前端：Vercel部署
后端：https://emotion-canvas-backend.herokuapp.com
数据库：PostgreSQL (免费)

echo.
echo 🎉 Heroku经典免费部署方案准备完成！
echo.
echo 📖 文档参考：https://devcenter.heroku.com/
echo.
pause