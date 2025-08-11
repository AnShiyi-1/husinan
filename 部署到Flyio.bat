@echo off
chcp 65001
title 🚀 部署到Fly.io - 全球CDN加速
cls
echo.
echo ======================================
echo     🚀 Fly.io 全球部署方案
     支持Docker容器化部署
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

:: 安装Fly.io CLI
echo.
echo 📦 安装Fly.io CLI...
powershell -Command "iwr https://fly.io/install.ps1 -useb | iex"

:: 2. 创建Fly.io配置
echo.
echo 📁 创建Fly.io配置...

:: 创建fly.toml
echo app = "emotion-canvas-backend" > fly.toml
echo primary_region = "sin" >> fly.toml

echo [build] >> fly.toml
echo   builder = "paketobuildpacks/builder:base" >> fly.toml

echo [env] >> fly.toml
echo   PORT = "8080" >> fly.toml
echo   NODE_ENV = "production" >> fly.toml

echo [[services]] >> fly.toml
echo   internal_port = 8080 >> fly.toml
echo   protocol = "tcp" >> fly.toml

echo [[services.ports]] >> fly.toml
echo   handlers = ["http"] >> fly.toml
echo   port = 80 >> fly.toml

echo [[services.ports]] >> fly.toml
echo   handlers = ["tls", "http"] >> fly.toml
echo   port = 443 >> fly.toml

echo [mounts] >> fly.toml
echo   source = "data" >> fly.toml
echo   destination = "/data" >> fly.toml

echo ✅ Fly.toml创建完成

:: 3. 创建Dockerfile
echo.
echo 🐳 创建Dockerfile...

echo FROM node:18-alpine > Dockerfile
echo WORKDIR /app >> Dockerfile
echo COPY package*.json ./ >> Dockerfile
echo RUN npm ci --only=production >> Dockerfile
echo COPY . . >> Dockerfile
echo EXPOSE 8080 >> Dockerfile
echo CMD ["node", "server/index.js"] >> Dockerfile

echo ✅ Dockerfile创建完成

:: 4. 创建.dockerignore
echo.
echo 📝 创建.dockerignore...

echo node_modules > .dockerignore
echo .git > .dockerignore
echo .gitignore > .dockerignore
echo README.md > .dockerignore
echo .env > .dockerignore
echo .env.* > .dockerignore
echo dist > .dockerignore
echo build > .dockerignore
echo *.log > .dockerignore

echo ✅ .dockerignore创建完成

:: 5. 创建部署脚本
echo.
echo 📝 创建部署脚本...

echo @echo off > deploy-flyio.bat
echo title 🚀 Fly.io一键部署 >> deploy-flyio.bat
echo echo 正在准备Fly.io部署... >> deploy-flyio.bat
echo echo. >> deploy-flyio.bat
echo echo 步骤1：登录Fly.io >> deploy-flyio.bat
echo fly auth login >> deploy-flyio.bat
echo echo. >> deploy-flyio.bat
echo echo 步骤2：创建应用 >> deploy-flyio.bat
echo fly launch --name emotion-canvas-backend --region sin >> deploy-flyio.bat
echo echo. >> deploy-flyio.bat
echo echo 步骤3：部署应用 >> deploy-flyio.bat
echo fly deploy >> deploy-flyio.bat
echo echo. >> deploy-flyio.bat
echo echo 步骤4：查看应用 >> deploy-flyio.bat
echo fly status >> deploy-flyio.bat
echo echo. >> deploy-flyio.bat
echo echo 🎉 部署完成！ >> deploy-flyio.bat
echo echo 访问地址：https://emotion-canvas-backend.fly.dev >> deploy-flyio.bat
echo pause >> deploy-flyio.bat

echo ✅ 部署脚本创建完成

:: 6. 创建环境变量模板
echo.
echo 📋 创建环境变量模板...

echo # Fly.io 环境变量 > .env.flyio
echo NODE_ENV=production >> .env.flyio
echo PORT=8080 >> .env.flyio
echo DATABASE_URL=postgres://user:pass@host:5432/dbname >> .env.flyio
echo SUPABASE_URL=你的SupabaseURL >> .env.flyio
echo SUPABASE_KEY=你的SupabaseKey >> .env.flyio
echo JWT_SECRET=你的JWT密钥 >> .env.flyio

echo ✅ 环境变量模板创建完成

:: 7. 创建PostgreSQL配置
echo.
echo 🗄️ 创建PostgreSQL配置...

echo # Fly.io PostgreSQL 创建脚本 > create-postgres-flyio.txt
echo # 运行以下命令创建PostgreSQL数据库： >> create-postgres-flyio.txt
echo fly postgres create --name emotion-canvas-db >> create-postgres-flyio.txt
echo fly postgres connect --app emotion-canvas-db >> create-postgres-flyio.txt
echo fly postgres connect --app emotion-canvas-db --command "CREATE DATABASE emotion_canvas;" >> create-postgres-flyio.txt
echo fly postgres connect --app emotion-canvas-db --command "CREATE USER emotion_user WITH PASSWORD 'your_password';" >> create-postgres-flyio.txt
echo fly postgres connect --app emotion-canvas-db --command "GRANT ALL PRIVILEGES ON DATABASE emotion_canvas TO emotion_user;" >> create-postgres-flyio.txt
echo fly secrets set DATABASE_URL=postgres://emotion_user:your_password@emotion-canvas-db.internal:5432/emotion_canvas --app emotion-canvas-backend >> create-postgres-flyio.txt

echo ✅ PostgreSQL配置创建完成

:: 8. 最终指导
echo.
echo 🎯 Fly.io部署步骤：
echo.
echo 1️⃣  安装Fly.io CLI：运行 deploy-flyio.bat
2️⃣  登录账号：fly auth login
3️⃣  创建应用：fly launch
4️⃣  部署应用：fly deploy
5️⃣  获得域名：xxx.fly.dev

echo.
echo 📱 最终访问地址：
echo 前端：Vercel部署
后端：https://emotion-canvas-backend.fly.dev
数据库：PostgreSQL (免费512MB)

echo.
echo 🎉 Fly.io全球部署方案准备完成！
echo.
echo 📖 文档参考：https://fly.io/docs/
echo.
pause