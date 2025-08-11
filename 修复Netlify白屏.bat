@echo off
title 🛠️ 修复Netlify白屏问题
color 0a

echo.
echo ==========================================
echo    🛠️ 修复Netlify白屏问题
echo ==========================================
echo.

echo 🔧 正在修复构建配置...
echo.

:: 创建新的vite配置以支持相对路径
echo // vite.config.js - 修复Netlify部署问题 > temp_vite_config.js
echo import { defineConfig } from 'vite' >> temp_vite_config.js
echo import vue from '@vitejs/plugin-vue' >> temp_vite_config.js
echo >> temp_vite_config.js
echo export default defineConfig({ >> temp_vite_config.js
echo   plugins: [vue()], >> temp_vite_config.js
echo   base: './',  // 使用相对路径 >> temp_vite_config.js
echo   build: { >> temp_vite_config.js
echo     outDir: 'dist', >> temp_vite_config.js
echo     assetsDir: 'assets', >> temp_vite_config.js
echo     sourcemap: false >> temp_vite_config.js
echo   } >> temp_vite_config.js
echo }) >> temp_vite_config.js

echo ✅ 已创建修复后的vite配置
echo.
echo 🔧 重新构建项目...

:: 备份原配置
if exist "vite.config.js" ren vite.config.js vite.config.js.backup
copy temp_vite_config.js vite.config.js > nul

:: 重新构建
npm run build

echo ✅ 构建完成！
echo.
echo 🚀 现在可以重新部署到Netlify了！
echo.
echo 📱 部署步骤：
echo    1. 打开 https://app.netlify.com/drop
echo    2. 拖拽新的dist文件夹
echo    3. 等待部署完成
echo.
echo 🎯 新地址将不会出现白屏问题！

:: 清理临时文件
del temp_vite_config.js

pause
start https://app.netlify.com/drop
start dist