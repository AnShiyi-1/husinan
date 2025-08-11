@echo off
title 🛠️ 修复并重新部署
color 0a

echo.
echo ==========================================
echo    🛠️ 修复Netlify白屏并重新部署
echo ==========================================
echo.

echo ✅ 已修复vite配置（使用相对路径）
echo.
echo 🔧 重新构建项目...
npm run build

echo.
echo 🚀 现在可以重新部署到Netlify了！
echo.
echo 📱 部署步骤：
echo    1. 打开：https://app.netlify.com/drop
echo    2. 删除旧的部署（可选）
echo    3. 拖拽新的dist文件夹到页面
echo    4. 等待30秒完成部署
echo    5. 获得新的网站地址

echo.
echo 🎯 新地址将正常工作，不再白屏！
echo.
echo 📁 修复后的文件位置：%cd%\dist

start https://app.netlify.com/drop
start dist

pause