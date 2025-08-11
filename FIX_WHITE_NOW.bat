@echo off
title 一键修复白屏问题
color 2f

echo.
echo ======================================
echo    情绪画布 - 白屏问题修复工具
echo ======================================
echo.

:: 检查dist文件夹是否存在
if not exist "dist\index.html" (
    echo ❌ 错误：dist文件夹中缺少index.html
    echo.
    echo 正在重新构建项目...
    call npm run build
    if errorlevel 1 (
        echo ❌ 构建失败，请检查项目配置
        pause
        exit /b 1
    )
)

echo ✅ 检测到dist文件夹和index.html

:: 创建修复后的文件
echo 正在创建修复版文件...

:: 创建修复后的index.html
echo ^<!DOCTYPE html^> > dist\index-fixed.html
echo ^<html lang="zh-CN"^> >> dist\index-fixed.html
echo ^<head^> >> dist\index-fixed.html
echo     ^<meta charset="UTF-8"^> >> dist\index-fixed.html
echo     ^<meta name="viewport" content="width=device-width, initial-scale=1.0"^> >> dist\index-fixed.html
echo     ^<title^>情绪画布 - 绘画创作平台^</title^> >> dist\index-fixed.html
echo     ^<link rel="icon" type="image/svg+xml" href="./hb.svg"^> >> dist\index-fixed.html
echo     ^<script type="module" crossorigin src="./assets/index.js"^>^</script^> >> dist\index-fixed.html
echo     ^<link rel="stylesheet" href="./assets/index.css"^>^</link^> >> dist\index-fixed.html
echo ^</head^> >> dist\index-fixed.html
echo ^<body^> >> dist\index-fixed.html
echo     ^<div id="app"^>^</div^> >> dist\index-fixed.html
echo     ^<div style="text-align: center; margin-top: 50px; font-family: Arial, sans-serif;"^> >> dist\index-fixed.html
echo         ^<h1^>🎨 情绪画布加载中...^</h1^> >> dist\index-fixed.html
echo         ^<p^>如果长时间停留在此页面，请按F12打开开发者工具查看错误信息^</p^> >> dist\index-fixed.html
echo     ^</div^> >> dist\index-fixed.html
echo ^</body^> >> dist\index-fixed.html
echo ^</html^> >> dist\index-fixed.html

:: 备份原始文件
copy dist\index.html dist\index-backup.html > nul
copy dist\index-fixed.html dist\index.html > nul

echo ✅ 已创建修复版index.html

:: 检查assets文件夹
echo 检查assets文件夹...
if exist "dist\assets" (
    echo ✅ assets文件夹存在
    dir dist\assets\*.js /b > nul 2>&1 && echo ✅ JS文件存在 || echo ❌ JS文件缺失
    dir dist\assets\*.css /b > nul 2>&1 && echo ✅ CSS文件存在 || echo ❌ CSS文件缺失
) else (
    echo ❌ assets文件夹缺失
)

:: 检查SVG图标
echo 检查SVG图标...
if exist "dist\*.svg" (
    echo ✅ SVG图标文件存在
) else (
    echo ⚠️ SVG图标文件缺失，不影响主要功能
)

:: 创建上传包
echo 正在创建上传包...
cd dist
if exist "..\white-screen-fix.zip" del "..\white-screen-fix.zip"
powershell -command "Compress-Archive -Path index.html,assets\*,*.svg -DestinationPath ..\white-screen-fix.zip -Force"
cd ..

echo.
echo ======================================
echo ✅ 修复完成！
echo.
echo 📁 修复文件已准备：
echo   - white-screen-fix.zip (上传包)
echo   - dist/index.html (修复版)
echo.
echo 🔗 下一步操作：
echo   1. 打开GitHub仓库：
echo      https://github.com/AnShiyi-1/qxhb
   2. 上传white-screen-fix.zip中的所有文件
   3. 等待5分钟后访问：
echo      https://anshiyi-1.github.io/qxhb/
echo.
echo 按任意键打开GitHub仓库...
pause > nul
start https://github.com/AnShiyi-1/qxhb