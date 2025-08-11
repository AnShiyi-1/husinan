@echo off
chcp 65001
cls
echo.
echo =====================================
echo 🎯 Supabase 一键部署工具
echo =====================================
echo.

:check_node
echo 检查Node.js环境...
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Node.js 未安装，请先安装Node.js
    pause
    exit /b 1
)
echo ✅ Node.js 已安装

:check_supabase
echo 检查Supabase CLI...
supabase --version >nul 2>&1
if %errorlevel% neq 0 (
    echo 📦 安装Supabase CLI...
    npm install -g supabase
)
echo ✅ Supabase CLI 已安装

:login_supabase
echo.
echo 🔐 登录Supabase...
supabase login

:create_project
echo.
echo 🚀 创建新项目...
echo 请访问：https://app.supabase.com
pause

:setup_project
echo.
echo 📁 设置项目...
if not exist .env (
    copy .env.example .env
    echo ✅ 已创建.env文件
)

:install_deps
echo.
echo 📦 安装依赖...
npm install @supabase/supabase-js

:deploy_database
echo.
echo 🗄️ 部署数据库...
supabase db push supabase_schema.sql

:success
echo.
echo =====================================
echo 🎉 部署完成！
echo =====================================
echo 下一步：
echo 1. 打开 .env 文件
echo 2. 填入你的Supabase URL和Key
echo 3. 运行：npm run dev
pause