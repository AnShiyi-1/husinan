@echo off
chcp 65001
title 🎯 部署到Render - 完整后端方案
cls
echo.
echo ======================================
echo     🎯 Render 完整后端部署方案
     支持Express + PostgreSQL
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

echo ✅ 环境检查通过

:: 2. 创建Render配置
echo.
echo 📁 创建Render配置...

:: 创建render.yaml
echo services: > render.yaml
echo   - type: web >> render.yaml
echo     name: emotion-canvas-backend >> render.yaml
echo     env: node >> render.yaml
echo     region: singapore >> render.yaml
echo     buildCommand: npm install >> render.yaml
echo     startCommand: node server/index.js >> render.yaml
echo     envVars: >> render.yaml
echo       - key: NODE_ENV >> render.yaml
echo         value: production >> render.yaml
echo       - key: PORT >> render.yaml
echo         value: 10000 >> render.yaml
echo       - key: DATABASE_URL >> render.yaml
echo         fromDatabase: >> render.yaml
echo           name: emotion-db >> render.yaml
echo           property: connectionString >> render.yaml
echo databases: >> render.yaml
echo   - name: emotion-db >> render.yaml
echo     databaseName: emotion_canvas >> render.yaml
echo     user: emotion_user >> render.yaml
echo     plan: starter >> render.yaml

echo ✅ Render配置创建完成

:: 3. 创建Procfile
echo web: node server/index.js > Procfile

:: 4. 更新package.json
echo 📦 更新package.json...
echo {
    "name": "emotion-canvas-backend",
    "version": "1.0.0",
    "description": "Emotion Canvas Backend API",
    "main": "server/index.js",
    "scripts": {
        "start": "node server/index.js",
        "dev": "nodemon server/index.js"
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
} > package-render.json

echo ✅ 后端package.json创建完成

:: 5. 创建部署脚本
echo.
echo 📝 创建部署脚本...

echo @echo off > deploy-render.bat
echo title 🚀 Render一键部署 >> deploy-render.bat
echo echo 正在准备Render部署... >> deploy-render.bat
echo echo. >> deploy-render.bat
echo echo 步骤1：访问 https://render.com >> deploy-render.bat
echo echo 步骤2：注册账号 >> deploy-render.bat
echo echo 步骤3：创建Web Service >> deploy-render.bat
echo echo 步骤4：连接GitHub仓库 >> deploy-render.bat
echo echo 步骤5：配置环境变量 >> deploy-render.bat
echo echo 步骤6：一键部署 >> deploy-render.bat
echo start https://render.com >> deploy-render.bat
echo pause >> deploy-render.bat

echo ✅ 部署脚本创建完成

:: 6. 创建环境变量模板
echo.
echo 📋 创建环境变量模板...

echo # Render 环境变量 > .env.render
echo NODE_ENV=production >> .env.render
echo PORT=10000 >> .env.render
echo DATABASE_URL=postgres://user:pass@host:5432/dbname >> .env.render
echo SUPABASE_URL=你的SupabaseURL >> .env.render
echo SUPABASE_KEY=你的SupabaseKey >> .env.render
echo JWT_SECRET=你的JWT密钥 >> .env.render
echo EMAIL_HOST=smtp.gmail.com >> .env.render
echo EMAIL_PORT=587 >> .env.render
echo EMAIL_USER=你的邮箱 >> .env.render
echo EMAIL_PASS=你的邮箱密码 >> .env.render

echo ✅ 环境变量模板创建完成

:: 7. 创建数据库初始化脚本
echo.
echo 🗄️ 创建数据库初始化脚本...

echo -- Render PostgreSQL 初始化脚本 > render_db_init.sql
echo -- 用户表 >> render_db_init.sql
echo CREATE TABLE IF NOT EXISTS users (^ >> render_db_init.sql
echo   id SERIAL PRIMARY KEY,^ >> render_db_init.sql
echo   email VARCHAR(255) UNIQUE NOT NULL,^ >> render_db_init.sql
echo   username VARCHAR(50) UNIQUE NOT NULL,^ >> render_db_init.sql
echo   password_hash VARCHAR(255) NOT NULL,^ >> render_db_init.sql
echo   avatar_url TEXT,^ >> render_db_init.sql
echo   created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,^ >> render_db_init.sql
echo   updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP^ >> render_db_init.sql
echo ); >> render_db_init.sql
echo. >> render_db_init.sql
echo -- 情绪记录表 >> render_db_init.sql
echo CREATE TABLE IF NOT EXISTS emotions (^ >> render_db_init.sql
echo   id SERIAL PRIMARY KEY,^ >> render_db_init.sql
echo   user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,^ >> render_db_init.sql
echo   emotion_type VARCHAR(20) NOT NULL,^ >> render_db_init.sql
echo   intensity INTEGER CHECK (intensity >= 1 AND intensity <= 10),^ >> render_db_init.sql
echo   description TEXT,^ >> render_db_init.sql
echo   created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP^ >> render_db_init.sql
echo ); >> render_db_init.sql
echo. >> render_db_init.sql
echo -- 画布记录表 >> render_db_init.sql
echo CREATE TABLE IF NOT EXISTS artworks (^ >> render_db_init.sql
echo   id SERIAL PRIMARY KEY,^ >> render_db_init.sql
echo   user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,^ >> render_db_init.sql
echo   title VARCHAR(255),^ >> render_db_init.sql
echo   canvas_data JSONB,^ >> render_db_init.sql
echo   image_url TEXT,^ >> render_db_init.sql
echo   created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,^ >> render_db_init.sql
echo   updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP^ >> render_db_init.sql
echo ); >> render_db_init.sql

echo ✅ 数据库脚本创建完成

:: 8. 最终指导
echo.
echo 🎯 Render部署步骤：
echo.
echo 1️⃣  注册Render：start https://render.com
2️⃣  创建Web Service
3️⃣  连接GitHub仓库
4️⃣  配置环境变量
5️⃣  一键部署
6️⃣  获得域名：xxx.onrender.com

echo.
echo 📱 最终访问地址：
echo 前端：Vercel部署
后端：https://xxx.onrender.com
数据库：PostgreSQL (免费)

echo.
echo 🎉 Render完整后端部署方案准备完成！
echo.
pause