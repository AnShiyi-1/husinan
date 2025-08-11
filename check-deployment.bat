@echo off
echo 🔍 检查部署状态...
echo.

:: 检查本地构建
echo 📂 检查本地构建...
if exist "dist\index.html" (
    echo ✅ 前端构建成功
) else (
    echo ❌ 前端构建失败
    echo 🔄 正在重新构建...
    npm run build
)

echo.
echo 🌐 测试部署地址...
echo.
echo 尝试访问: https://emotion-canvas-b1285o59o-anshiyi-1s-projects.vercel.app/
echo.
echo 如果无法访问，建议：
echo 1. 使用Netlify部署: 访问 https://app.netlify.com/drop
echo 2. 将dist文件夹拖拽到Netlify进行部署
echo 3. 或使用Render部署后端

echo.
pause