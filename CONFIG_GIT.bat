@echo off
title Git身份配置助手
color 2f

echo.
echo ======================================
echo    Git身份配置 - 解决提交问题
echo ======================================
echo.

echo ❗ 检测到Git身份未配置

echo.
echo 正在为你配置Git身份...
echo.

:: 设置全局用户名和邮箱
git config --global user.name "AnShiyi-1"
git config --global user.email "anshiyi-1@users.noreply.github.com"

:: 验证配置
echo ✅ 配置完成！
echo.
echo 📋 当前配置：
git config --global user.name
git config --global user.email
echo.

echo 🎯 现在你可以正常提交代码了！
echo.
echo 📖 常用Git命令：
echo   git add .          - 添加所有文件
echo   git commit -m "描述" - 提交更改
echo   git push          - 推送到远程仓库
echo.

:: 提供重新配置的选项
echo 💡 如果需要修改配置：
echo   git config --global user.name "新用户名"
echo   git config --global user.email "新邮箱"
echo.

pause