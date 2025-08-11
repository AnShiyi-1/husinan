@echo off
chcp 65001 >nul
title 🌐 一键部署到网站
color 0a

echo.
echo ==========================================
echo    🎨 一键部署情绪画布到真实网站
echo ==========================================
echo.

:: 步骤1: 构建项目
echo 🔧 步骤1: 构建生产版本...
npm run build
if errorlevel 1 (
    echo ❌ 构建失败，请检查项目
    pause
    exit /b 1
)

:: 步骤2: 部署到腾讯云CloudBase
echo 🚀 步骤2: 部署到腾讯云CloudBase...
echo.
echo 📱 正在登录腾讯云...
cloudbase login

:: 步骤3: 部署应用
echo 📦 正在部署应用...
cloudbase hosting:deploy dist -e emotion-canvas-123456789

:: 步骤4: 显示结果
echo.
echo ✅ 部署完成！
echo.
echo 🎯 您的网站地址：
echo    https://emotion-canvas-123456789.tcloudbaseapp.com

echo.
echo 🚀 其他部署选项：
echo.
echo 1. Netlify (免费国际平台)
   npx netlify-cli deploy --prod --dir=dist
   
echo 2. Vercel (免费国际平台)
   npx vercel --prod
   
echo 3. GitHub Pages (免费静态托管)
   使用一键GitHub部署脚本

echo.
echo 📱 手机访问测试：
echo    直接访问上面的网址即可

echo.
echo 🔗 立即可用地址：
echo    https://emotion-canvas-123456789.tcloudbaseapp.com

pause
start https://emotion-canvas-123456789.tcloudbaseapp.com