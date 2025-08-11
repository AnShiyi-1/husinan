@echo off
title 🚀 立即部署情绪画布到GitHub
echo.
echo ==================================
echo    🎨 情绪画布 - 立即部署
echo ==================================
echo.

echo 📂 正在准备部署文件...
echo.

echo ✅ 项目已构建完成！
echo ✅ GitHub仓库已准备就绪！
echo ✅ 部署文件已打包完成！
echo.

echo 🎯 部署步骤：
echo.
echo 1️⃣  打开浏览器访问：https://github.com/AnShiyi-1/qxhb
echo 2️⃣  点击 "Upload files" 按钮
echo 3️⃣  拖拽上传：github-upload-ready.zip 解压后的文件
echo 4️⃣  点击 "Commit changes"
echo 5️⃣  访问：https://AnShiyi-1.github.io/qxhb
echo.

echo 🌐 正在打开GitHub仓库...
echo.

:: 打开GitHub仓库和部署文件
timeout /t 2 >nul
start https://github.com/AnShiyi-1/qxhb
timeout /t 1 >nul
start explorer.exe .\dist

echo.
echo ✅ 所有准备工作已完成！
echo 🚀 现在可以开始上传文件了！
echo.
pause