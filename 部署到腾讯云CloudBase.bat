@echo off
chcp 65001
title 🌤️ 部署到腾讯云CloudBase - 国内免费方案
cls
echo.
echo ======================================
echo     🌤️ 腾讯云CloudBase 国内部署
     支持Node.js + MySQL + CDN
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

:: 安装CloudBase CLI
echo.
echo 📦 安装腾讯云CloudBase CLI...
powershell -Command "npm install -g @cloudbase/cli"

:: 2. 创建CloudBase配置
echo.
echo 📁 创建CloudBase配置...

:: 创建cloudbaserc.json
echo { > cloudbaserc.json
echo   "envId": "emotion-canvas-123456789", >> cloudbaserc.json
echo   "region": "ap-shanghai", >> cloudbaserc.json
echo   "functionRoot": "./cloudfunctions", >> cloudbaserc.json
echo   "functions": [ >> cloudbaserc.json
echo     { >> cloudbaserc.json
echo       "name": "emotion-api", >> cloudbaserc.json
echo       "timeout": 5, >> cloudbaserc.json
echo       "envVariables": { >> cloudbaserc.json
echo         "NODE_ENV": "production" >> cloudbaserc.json
echo       }, >> cloudbaserc.json
echo       "runtime": "Nodejs16.13", >> cloudbaserc.json
echo       "handler": "index.main" >> cloudbaserc.json
echo     } >> cloudbaserc.json
echo   ], >> cloudbaserc.json
echo   "static": [ >> cloudbaserc.json
echo     { >> cloudbaserc.json
echo       "src": "./dist", >> cloudbaserc.json
echo       "cloudPath": "/", >> cloudbaserc.json
echo       "headers": { >> cloudbaserc.json
echo         "Cache-Control": "max-age=31536000" >> cloudbaserc.json
echo       } >> cloudbaserc.json
echo     } >> cloudbaserc.json
echo   ] >> cloudbaserc.json
echo } >> cloudbaserc.json

echo ✅ CloudBase配置创建完成

:: 3. 创建云函数目录
echo.
echo 📁 创建云函数目录...
if not exist "cloudfunctions" mkdir cloudfunctions
if not exist "cloudfunctions\emotion-api" mkdir cloudfunctions\emotion-api

:: 创建云函数入口文件
echo const express = require('express'); > cloudfunctions\emotion-api\index.js
echo const cors = require('cors'); >> cloudfunctions\emotion-api\index.js
echo const app = express(); >> cloudfunctions\emotion-api\index.js
echo. >> cloudfunctions\emotion-api\index.js
echo app.use(cors()); >> cloudfunctions\emotion-api\index.js
echo app.use(express.json()); >> cloudfunctions\emotion-api\index.js
echo. >> cloudfunctions\emotion-api\index.js
echo app.get('/api/health', (req, res) => { >> cloudfunctions\emotion-api\index.js
echo   res.json({ status: 'OK', service: 'Emotion Canvas API' }); >> cloudfunctions\emotion-api\index.js
echo }); >> cloudfunctions\emotion-api\index.js
echo. >> cloudfunctions\emotion-api\index.js
echo app.get('/api/test', (req, res) => { >> cloudfunctions\emotion-api\index.js
echo   res.json({ message: 'CloudBase云函数部署成功！' }); >> cloudfunctions\emotion-api\index.js
echo }); >> cloudfunctions\emotion-api\index.js
echo. >> cloudfunctions\emotion-api\index.js
echo exports.main = app; >> cloudfunctions\emotion-api\index.js

:: 创建云函数package.json
echo { > cloudfunctions\emotion-api\package.json
echo   "name": "emotion-api", >> cloudfunctions\emotion-api\package.json
echo   "version": "1.0.0", >> cloudfunctions\emotion-api\package.json
echo   "description": "Emotion Canvas CloudBase API", >> cloudfunctions\emotion-api\package.json
echo   "main": "index.js", >> cloudfunctions\emotion-api\package.json
echo   "scripts": { >> cloudfunctions\emotion-api\package.json
echo     "start": "node index.js" >> cloudfunctions\emotion-api\package.json
echo   }, >> cloudfunctions\emotion-api\package.json
echo   "dependencies": { >> cloudfunctions\emotion-api\package.json
echo     "express": "^4.18.2", >> cloudfunctions\emotion-api\package.json
echo     "cors": "^2.8.5", >> cloudfunctions\emotion-api\package.json
echo     "mysql2": "^3.6.0" >> cloudfunctions\emotion-api\package.json
echo   } >> cloudfunctions\emotion-api\package.json
echo } >> cloudfunctions\emotion-api\package.json

echo ✅ 云函数创建完成

:: 4. 创建部署脚本
echo.
echo 📝 创建部署脚本...

echo @echo off > deploy-cloudbase.bat
echo title 🌤️ CloudBase一键部署 >> deploy-cloudbase.bat
echo echo 正在准备腾讯云CloudBase部署... >> deploy-cloudbase.bat
echo echo. >> deploy-cloudbase.bat
echo echo 步骤1：登录腾讯云 >> deploy-cloudbase.bat
echo tcb login >> deploy-cloudbase.bat
echo echo. >> deploy-cloudbase.bat
echo echo 步骤2：初始化项目 >> deploy-cloudbase.bat
echo tcb init >> deploy-cloudbase.bat
echo echo. >> deploy-cloudbase.bat
echo echo 步骤3：部署前端 >> deploy-cloudbase.bat
echo tcb hosting deploy ./dist -e emotion-canvas-123456789 >> deploy-cloudbase.bat
echo echo. >> deploy-cloudbase.bat
echo echo 步骤4：部署云函数 >> deploy-cloudbase.bat
echo tcb functions deploy emotion-api -e emotion-canvas-123456789 >> deploy-cloudbase.bat
echo echo. >> deploy-cloudbase.bat
echo echo 步骤5：查看部署结果 >> deploy-cloudbase.bat
echo tcb hosting detail -e emotion-canvas-123456789 >> deploy-cloudbase.bat
echo echo. >> deploy-cloudbase.bat
echo echo 🎉 部署完成！ >> deploy-cloudbase.bat
echo echo 访问地址：https://emotion-canvas-123456789.tcloudbaseapp.com >> deploy-cloudbase.bat
echo echo API地址：https://emotion-canvas-123456789.tcloudbaseapp.com/api >> deploy-cloudbase.bat
echo pause >> deploy-cloudbase.bat

echo ✅ 部署脚本创建完成

:: 5. 创建环境变量模板
echo.
echo 📋 创建环境变量模板...

echo # 腾讯云CloudBase 环境变量 > .env.cloudbase
echo NODE_ENV=production >> .env.cloudbase
echo TCB_ENV_ID=emotion-canvas-123456789 >> .env.cloudbase
echo TCB_REGION=ap-shanghai >> .env.cloudbase
echo MYSQL_HOST=你的MySQL主机 >> .env.cloudbase
echo MYSQL_USER=你的MySQL用户 >> .env.cloudbase
echo MYSQL_PASSWORD=你的MySQL密码 >> .env.cloudbase
echo MYSQL_DATABASE=emotion_canvas >> .env.cloudbase

echo ✅ 环境变量模板创建完成

:: 6. 创建MySQL初始化脚本
echo.
echo 🗄️ 创建MySQL初始化脚本...

echo -- 腾讯云CloudBase MySQL 初始化脚本 > cloudbase_mysql_init.sql
echo -- 用户表 >> cloudbase_mysql_init.sql
echo CREATE TABLE IF NOT EXISTS users (^ >> cloudbase_mysql_init.sql
echo   id INT AUTO_INCREMENT PRIMARY KEY,^ >> cloudbase_mysql_init.sql
echo   email VARCHAR(255) UNIQUE NOT NULL,^ >> cloudbase_mysql_init.sql
echo   username VARCHAR(50) UNIQUE NOT NULL,^ >> cloudbase_mysql_init.sql
echo   password_hash VARCHAR(255) NOT NULL,^ >> cloudbase_mysql_init.sql
echo   avatar_url TEXT,^ >> cloudbase_mysql_init.sql
echo   created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,^ >> cloudbase_mysql_init.sql
echo   updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP^ >> cloudbase_mysql_init.sql
echo ); >> cloudbase_mysql_init.sql
echo. >> cloudbase_mysql_init.sql
echo -- 情绪记录表 >> cloudbase_mysql_init.sql
echo CREATE TABLE IF NOT EXISTS emotions (^ >> cloudbase_mysql_init.sql
echo   id INT AUTO_INCREMENT PRIMARY KEY,^ >> cloudbase_mysql_init.sql
echo   user_id INT NOT NULL,^ >> cloudbase_mysql_init.sql
echo   emotion_type VARCHAR(20) NOT NULL,^ >> cloudbase_mysql_init.sql
echo   intensity INT CHECK (intensity >= 1 AND intensity <= 10),^ >> cloudbase_mysql_init.sql
echo   description TEXT,^ >> cloudbase_mysql_init.sql
echo   created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,^ >> cloudbase_mysql_init.sql
echo   FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE^ >> cloudbase_mysql_init.sql
echo ); >> cloudbase_mysql_init.sql
echo. >> cloudbase_mysql_init.sql
echo -- 画布记录表 >> cloudbase_mysql_init.sql
echo CREATE TABLE IF NOT EXISTS artworks (^ >> cloudbase_mysql_init.sql
echo   id INT AUTO_INCREMENT PRIMARY KEY,^ >> cloudbase_mysql_init.sql
echo   user_id INT NOT NULL,^ >> cloudbase_mysql_init.sql
echo   title VARCHAR(255),^ >> cloudbase_mysql_init.sql
echo   canvas_data JSON,^ >> cloudbase_mysql_init.sql
echo   image_url TEXT,^ >> cloudbase_mysql_init.sql
echo   created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,^ >> cloudbase_mysql_init.sql
echo   updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,^ >> cloudbase_mysql_init.sql
echo   FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE^ >> cloudbase_mysql_init.sql
echo ); >> cloudbase_mysql_init.sql

echo ✅ MySQL初始化脚本创建完成

:: 7. 创建CloudBase部署指南
echo.
echo 📖 创建CloudBase部署指南...

echo # 腾讯云CloudBase部署指南 > cloudbase-deploy-guide.txt
echo. >> cloudbase-deploy-guide.txt
echo ## 免费额度 >> cloudbase-deploy-guide.txt
echo - 云函数：每月100万次调用 >> cloudbase-deploy-guide.txt
echo - 云托管：1GB内存，每天1小时 >> cloudbase-deploy-guide.txt
echo - 静态托管：1GB存储，每月1GB流量 >> cloudbase-deploy-guide.txt
echo - 数据库：MySQL免费版 >> cloudbase-deploy-guide.txt
echo. >> cloudbase-deploy-guide.txt
echo ## 部署步骤 >> cloudbase-deploy-guide.txt
echo 1. 注册腾讯云账号：https://cloud.tencent.com >> cloudbase-deploy-guide.txt
echo 2. 开通CloudBase服务 >> cloudbase-deploy-guide.txt
echo 3. 创建环境：emotion-canvas-123456789 >> cloudbase-deploy-guide.txt
echo 4. 运行 deploy-cloudbase.bat >> cloudbase-deploy-guide.txt
echo 5. 一键部署到国内CDN >> cloudbase-deploy-guide.txt
echo. >> cloudbase-deploy-guide.txt
echo ## 访问地址 >> cloudbase-deploy-guide.txt
echo 前端：https://emotion-canvas-123456789.tcloudbaseapp.com >> cloudbase-deploy-guide.txt
echo 后端：https://emotion-canvas-123456789.tcloudbaseapp.com/api >> cloudbase-deploy-guide.txt
echo. >> cloudbase-deploy-guide.txt
echo ## 优势 >> cloudbase-deploy-guide.txt
echo - 国内访问速度快 >> cloudbase-deploy-guide.txt
echo - 支持微信登录 >> cloudbase-deploy-guide.txt
echo - 免费HTTPS证书 >> cloudbase-deploy-guide.txt
echo - 微信云开发集成 >> cloudbase-deploy-guide.txt

echo ✅ CloudBase部署指南创建完成

:: 8. 最终指导
echo.
echo 🎯 腾讯云CloudBase部署步骤：
echo.
echo 1️⃣  注册腾讯云：https://cloud.tencent.com
2️⃣  开通CloudBase服务
3️⃣  运行 deploy-cloudbase.bat
4️⃣  一键部署到国内CDN
5️⃣  获得域名：xxx.tcloudbaseapp.com

echo.
echo 📱 最终访问地址：
echo 前端：https://emotion-canvas-123456789.tcloudbaseapp.com
后端：https://emotion-canvas-123456789.tcloudbaseapp.com/api
数据库：MySQL (免费)

echo.
echo 🎉 腾讯云CloudBase国内部署方案准备完成！
echo.
echo 📖 文档参考：https://cloud.tencent.com/document/product/876

echo.
echo 💡 提示：CloudBase适合国内用户，访问速度最快！
echo.
pause