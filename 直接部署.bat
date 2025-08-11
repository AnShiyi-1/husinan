@echo off
title 🌐 直接部署到网站
color 0a

echo.
echo ==========================================
echo    🎨 情绪画布 - 直接部署到网站
echo ==========================================
echo.

echo 🔧 构建项目...
npm run build

echo 🚀 正在部署...
echo.
echo 📋 请选择部署平台：
echo.
echo 1. Netlify - 拖拽 dist 文件夹到：https://app.netlify.com/drop
echo 2. Vercel - 导入项目：https://vercel.com/new
echo 3. GitHub Pages - 创建仓库并上传 dist 文件夹
echo.

echo 🎯 立即可用地址：
echo    部署完成后即可获得真实网站地址

echo.
echo 📁 构建文件位置：%cd%\dist

start %cd%\dist
start https://app.netlify.com/drop

pause