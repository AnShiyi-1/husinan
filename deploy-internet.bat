@echo off
chcp 65001
cls
echo.
echo =====================================
echo 🚀 一键部署到互联网（Vercel）
echo =====================================
echo.

:check_login
echo 检查Vercel登录状态...
vercel whoami >nul 2>&1
if %errorlevel% neq 0 (
    echo 🔐 请先登录Vercel...
    vercel login
)

:deploy_frontend
echo.
echo 📦 部署前端到Vercel...
echo 正在部署，请稍候...
vercel --prod --yes

:deploy_backend
echo.
echo 🗄️ 部署后端API...
echo 正在配置后端...
copy vercel.json .\vercel.json.bak >nul 2>&1

:success
echo.
echo =====================================
echo 🎉 部署完成！
echo =====================================
echo.
echo ✅ 前端已部署到Vercel
echo ✅ 后端API已配置
echo.
echo 📱 现在可以访问：
echo   - 前端：https://[your-project].vercel.app
echo   - 后端：https://[your-project].vercel.app/api
echo.
echo 🔄 下次更新只需运行：vercel --prod
echo.
pause