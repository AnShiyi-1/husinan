@echo off
echo 🚀 正在修复Vercel部署问题...
echo.

:: 确保构建文件存在
echo 📦 正在构建应用...
call npm run build

:: 清理旧的Vercel配置
echo 🧹 正在清理配置...
if exist .vercel rmdir /s /q .vercel

:: 重新部署
echo 🌐 正在重新部署...
call vercel --prod --yes

echo.
echo ✅ 修复完成！
echo 🌐 访问地址：https://emotion-canvas-nzpwuyhbr-anshiyi-1s-projects.vercel.app
pause