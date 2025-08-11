@echo off
echo 🚀 正在部署到Render...
echo.

:: 检查git状态
echo 📂 检查Git状态...
git status

:: 添加所有文件
echo ➕ 添加文件到Git...
git add .

:: 提交更改
echo 💾 提交更改...
git commit -m "准备部署到Render"

:: 推送到GitHub（假设已配置）
echo 🔄 推送到GitHub...
git push origin main

echo.
echo ✅ 代码已推送到GitHub！
echo.
echo 🌐 下一步：
echo 1. 访问 https://render.com
echo 2. 连接你的GitHub仓库
echo 3. 选择项目并部署
echo.
echo 📋 部署完成后，复制Render提供的URL
echo.
pause