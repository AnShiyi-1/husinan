@echo off
chcp 65001
title 🎯 初学者一键部署 - Vercel+Railway
cls
echo.
echo ======================================
echo     🎯 初学者一键部署方案
echo     Vercel前端 + Railway后端
echo ======================================
echo.

:: 1. 环境检查
echo 🔍 检查环境...

:: 检查Node.js
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Node.js 未安装
    echo 📥 请访问 https://nodejs.org 下载安装后重试
    pause
    exit /b
)

:: 检查Git
git --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Git 未安装
    echo 📥 请访问 https://git-scm.com 下载安装后重试
    pause
    exit /b
)

:: 检查网络
echo 📡 检查网络连接...
ping -n 1 google.com >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ 网络连接异常
    pause
    exit /b
)

echo ✅ 环境检查通过

:: 2. 安装必要工具
echo.
echo 📦 安装部署工具...

:: 安装Vercel CLI
where vercel >nul 2>&1
if %errorlevel% neq 0 (
    echo 📥 安装 Vercel CLI...
    npm install -g vercel
)

:: 安装Railway CLI
where railway >nul 2>&1
if %errorlevel% neq 0 (
    echo 📥 安装 Railway CLI...
    npm install -g @railway/cli
)

echo ✅ 工具安装完成

:: 3. 准备项目
echo.
echo 📁 准备项目结构...

:: 创建前端配置
echo {
    "version": 2,
    "builds": [
        {
            "src": "package.json",
            "use": "@vercel/static-build",
            "config": {
                "distDir": "dist"
            }
        }
    ],
    "routes": [
        {
            "src": "/(.*)",
            "dest": "/dist/$1"
        }
    ]
} > vercel.json

:: 创建Railway配置
echo {
    "build": {
        "builder": "NIXPACKS"
    },
    "deploy": {
        "startCommand": "node server/index.js",
        "restartPolicyType": "ON_FAILURE"
    }
} > railway.json

echo ✅ 配置文件创建完成

:: 4. 构建项目
echo.
echo 🔨 构建项目...

call npm install
if %errorlevel% neq 0 (
    echo ❌ 依赖安装失败
    pause
    exit /b
)

call npm run build
if %errorlevel% neq 0 (
    echo ❌ 项目构建失败
    pause
    exit /b
)

echo ✅ 项目构建成功

:: 5. 创建部署指南
echo.
echo 📝 创建部署指南...

echo 📋 部署步骤指南 > 部署步骤.txt
echo ================= >> 部署步骤.txt
echo. >> 部署步骤.txt
echo 第一步：部署前端到Vercel >> 部署步骤.txt
echo 1. 访问 https://vercel.com >> 部署步骤.txt
echo 2. 点击 "New Project" >> 部署步骤.txt
echo 3. 导入整个项目仓库 >> 部署步骤.txt
echo 4. 点击 "Deploy" >> 部署步骤.txt
echo 5. 获得前端域名：xxx.vercel.app >> 部署步骤.txt
echo. >> 部署步骤.txt
echo 第二步：部署后端到Railway >> 部署步骤.txt
echo 1. 访问 https://railway.app >> 部署步骤.txt
echo 2. 创建新项目 >> 部署步骤.txt
echo 3. 选择 "Deploy from GitHub" >> 部署步骤.txt
echo 4. 选择同一个仓库 >> 部署步骤.txt
echo 5. 添加 PostgreSQL 数据库 >> 部署步骤.txt
echo 6. 配置环境变量 >> 部署步骤.txt
echo 7. 点击 "Deploy" >> 部署步骤.txt
echo 8. 获得后端域名：xxx.up.railway.app >> 部署步骤.txt
echo. >> 部署步骤.txt
echo 第三步：连接前后端 >> 部署步骤.txt
echo 1. 在Railway中获取后端域名 >> 部署步骤.txt
echo 2. 修改前端API配置 >> 部署步骤.txt
echo 3. 重新部署前端 >> 部署步骤.txt
echo. >> 部署步骤.txt
echo ✅ 完成！ >> 部署步骤.txt

echo ✅ 部署指南已创建：部署步骤.txt

:: 6. 打开部署页面
echo.
echo 🌐 正在打开部署平台...
echo. 
echo 📱 请选择以下方式开始部署：
echo.
echo 🎯 方式1：手动部署（推荐）
echo    - 访问 https://vercel.com 部署前端
echo    - 访问 https://railway.app 部署后端

echo.
echo 🎯 方式2：一键命令部署
start cmd /k "echo 前端部署命令: vercel --prod && echo 后端部署命令: railway login && railway deploy"

echo.
echo 📋 详细步骤已保存到：部署步骤.txt
echo.
echo 🎉 准备完成！现在可以开始部署了！
echo.
pause