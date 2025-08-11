@echo off
title 🌐 立即部署到网站
color 0a

echo.
echo ==========================================
echo    🎨 情绪画布 - 立即部署到网站
echo ==========================================
echo.

echo 🔧 正在构建...
npm run build

echo 🚀 正在部署到Netlify...
npx netlify-cli deploy --prod --dir=dist --open

echo ✅ 部署完成！网站已上线！
pause