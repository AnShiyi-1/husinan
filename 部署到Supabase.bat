@echo off
chcp 65001
title 🎯 部署到Supabase - 零后端代码方案
cls
echo.
echo ======================================
echo     🎯 Supabase 零后端部署方案
     无需写后端代码，直接调用API
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

echo ✅ Node.js 已安装

:: 2. 创建Supabase配置
echo.
echo 📁 创建Supabase配置...

:: 创建前端API配置
echo // Supabase 前端配置 > src\config\supabase.js
echo import { createClient } from '@supabase/supabase-js' >> src\config\supabase.js
echo. >> src\config\supabase.js
echo const supabaseUrl = import.meta.env.VITE_SUPABASE_URL >> src\config\supabase.js
echo const supabaseKey = import.meta.env.VITE_SUPABASE_KEY >> src\config\supabase.js
echo. >> src\config\supabase.js
echo export const supabase = createClient(supabaseUrl, supabaseKey) >> src\config\supabase.js

echo ✅ Supabase配置创建完成

:: 3. 创建环境变量模板
echo.
echo 📋 创建环境变量模板...

echo # Supabase 配置 > .env.supabase
echo VITE_SUPABASE_URL=你的Supabase项目URL >> .env.supabase
echo VITE_SUPABASE_KEY=你的anon公开密钥 >> .env.supabase
echo. >> .env.supabase
echo # 示例： >> .env.supabase
echo # VITE_SUPABASE_URL=https://xyzcompany.supabase.co >> .env.supabase
echo # VITE_SUPABASE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9... >> .env.supabase

echo ✅ 环境变量模板创建完成

:: 4. 安装Supabase客户端
echo.
echo 📦 安装Supabase客户端...
call npm install @supabase/supabase-js
if %errorlevel% neq 0 (
    echo ❌ 安装失败
    pause
    exit /b
)

echo ✅ Supabase客户端安装完成

:: 5. 创建一键部署脚本
echo.
echo 📝 创建一键部署脚本...

echo @echo off > deploy-supabase.bat
echo title 🚀 Supabase一键部署 >> deploy-supabase.bat
echo echo 正在部署到Supabase... >> deploy-supabase.bat
echo echo 请确保： >> deploy-supabase.bat
echo echo 1. 已注册 supabase.com >> deploy-supabase.bat
echo echo 2. 已创建项目 >> deploy-supabase.bat
echo echo 3. 已复制项目URL和密钥 >> deploy-supabase.bat
echo start https://supabase.com/dashboard >> deploy-supabase.bat
echo start https://vercel.com >> deploy-supabase.bat
echo echo 部署完成后，在.env文件中填入： >> deploy-supabase.bat
echo echo VITE_SUPABASE_URL=https://你的项目.supabase.co >> deploy-supabase.bat
echo echo VITE_SUPABASE_KEY=你的anon_key >> deploy-supabase.bat
echo pause >> deploy-supabase.bat

echo ✅ 一键部署脚本创建完成

:: 6. 创建数据库脚本
echo.
echo 🗄️ 创建数据库初始化脚本...

echo -- Supabase 数据库初始化脚本 > supabase_schema.sql
echo -- 用户表 >> supabase_schema.sql
echo CREATE TABLE IF NOT EXISTS users (^ >> supabase_schema.sql
echo   id UUID DEFAULT gen_random_uuid() PRIMARY KEY,^ >> supabase_schema.sql
echo   email VARCHAR(255) UNIQUE NOT NULL,^ >> supabase_schema.sql
echo   username VARCHAR(50) UNIQUE NOT NULL,^ >> supabase_schema.sql
echo   password_hash VARCHAR(255),^ >> supabase_schema.sql
echo   avatar_url TEXT,^ >> supabase_schema.sql
echo   created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),^ >> supabase_schema.sql
echo   updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()^ >> supabase_schema.sql
echo ); >> supabase_schema.sql
echo. >> supabase_schema.sql
echo -- 情绪记录表 >> supabase_schema.sql
echo CREATE TABLE IF NOT EXISTS emotions (^ >> supabase_schema.sql
echo   id UUID DEFAULT gen_random_uuid() PRIMARY KEY,^ >> supabase_schema.sql
echo   user_id UUID REFERENCES users(id) ON DELETE CASCADE,^ >> supabase_schema.sql
echo   emotion_type VARCHAR(20) NOT NULL,^ >> supabase_schema.sql
echo   intensity INTEGER CHECK (intensity >= 1 AND intensity <= 10),^ >> supabase_schema.sql
echo   description TEXT,^ >> supabase_schema.sql
echo   created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()^ >> supabase_schema.sql
echo ); >> supabase_schema.sql
echo. >> supabase_schema.sql
echo -- 画布记录表 >> supabase_schema.sql
echo CREATE TABLE IF NOT EXISTS artworks (^ >> supabase_schema.sql
echo   id UUID DEFAULT gen_random_uuid() PRIMARY KEY,^ >> supabase_schema.sql
echo   user_id UUID REFERENCES users(id) ON DELETE CASCADE,^ >> supabase_schema.sql
echo   title VARCHAR(255),^ >> supabase_schema.sql
echo   canvas_data JSONB,^ >> supabase_schema.sql
echo   image_url TEXT,^ >> supabase_schema.sql
echo   created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),^ >> supabase_schema.sql
echo   updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()^ >> supabase_schema.sql
echo ); >> supabase_schema.sql

echo ✅ 数据库脚本创建完成

:: 7. 最终指导
echo.
echo 🎯 部署步骤总结：
echo.
echo 1️⃣  注册Supabase：start https://supabase.com
2️⃣  创建新项目
3️⃣  复制项目URL和anon key
4️⃣  运行：npm run build
5️⃣  部署到Vercel：vercel --prod
6️⃣  在.env中填入Supabase配置
7️⃣  重新部署完成！
echo.
echo 📱 最终访问地址：
echo 前端：https://xxx.vercel.app
后端：使用Supabase API
数据库：Supabase托管

echo.
echo 🎉 零后端代码部署方案准备完成！
echo.
pause