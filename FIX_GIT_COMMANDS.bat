@echo off
title Git命令修复工具
color 2f

echo.
echo ======================================
echo    Git命令修复 - 正确语法指南
echo ======================================
echo.

echo ❌ 错误示例：
echo    git config --global user.name git config --global user.email
echo.

echo ✅ 正确用法：
echo.

echo 📋 设置用户名：
echo    git config --global user.name "AnShiyi-1"
echo.

echo 📧 设置邮箱：
echo    git config --global user.email "anshiyi-1@users.noreply.github.com"
echo.

echo 🔍 验证配置：
echo    git config --global user.name
echo    git config --global user.email
echo.

echo 🎯 正在为你执行正确配置...
echo.

:: 执行正确的配置命令
git config --global user.name "AnShiyi-1"
git config --global user.email "anshiyi-1@users.noreply.github.com"

echo ✅ 配置完成！
echo.
echo 📊 当前配置：
echo   用户名: 
git config --global user.name
echo   邮箱: 
git config --global user.email
echo.

echo 🚀 现在你可以正常使用了：
echo   git add .
echo   git commit -m "你的提交信息"
echo   git push origin main
echo.

pause