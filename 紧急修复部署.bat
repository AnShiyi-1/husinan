@echo off
echo 🚨 紧急修复部署方案
echo.

:: 方案1：使用Vercel重新部署
echo 正在尝试重新部署到Vercel...
vercel --prod --yes

:: 方案2：提供可访问的地址
echo.
echo ✅ 可用的部署地址：
echo.
echo 📍 确认可访问地址：
echo https://emotion-canvas-gdvsftsbu-anshiyi-1s-projects.vercel.app
echo.
echo 📍 备用地址：
echo https://emotion-canvas-bc2xsr5bp-anshiyi-1s-projects.vercel.app
echo https://emotion-canvas-8y99dyxzz-anshiyi-1s-projects.vercel.app
echo https://emotion-canvas-c9ek994uf-anshiyi-1s-projects.vercel.app
echo.
echo 📍 方案3：手动部署
echo 1. 访问 https://app.netlify.com/drop
echo 2. 拖拽 dist 文件夹到页面
echo 3. 获取新的访问地址

echo.
echo 🔄 如果以上都失败，请运行：
echo npm run build
echo vercel --prod

pause