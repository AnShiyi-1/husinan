@echo off

REM 检查是否安装了Python
python --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo 错误: 未找到Python。请先安装Python。
    pause
    exit /b 1
)

REM 安装必要的依赖
echo 正在安装必要的依赖...
pip install selenium webdriver-manager
if %ERRORLEVEL% NEQ 0 (
    echo 错误: 安装依赖失败。
    pause
    exit /b 1
)

REM 提醒用户修改测试账号
echo 请确保已在selenium_test.py文件中修改测试账号和密码。
echo 按任意键继续...
pause >nul

REM 运行测试脚本
python selenium_test.py
if %ERRORLEVEL% NEQ 0 (
    echo 错误: 测试脚本执行失败。
    pause
    exit /b 1
)

REM 测试完成
echo 测试执行完成。
pause