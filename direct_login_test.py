#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
直接测试登录页面 - 绕过导航问题
"""

import time
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.common.exceptions import TimeoutException

def test_direct_login():
    """直接访问登录页面测试"""
    driver = webdriver.Chrome()
    driver.maximize_window()
    
    try:
        # 直接访问登录页面
        login_url = "http://localhost:3000/#/login"
        print(f"直接访问登录页面: {login_url}")
        driver.get(login_url)
        
        # 等待页面加载
        time.sleep(3)
        
        # 确认在登录页面
        if "#/login" not in driver.current_url:
            print(f"❌ 未在登录页面，当前URL: {driver.current_url}")
            return False
            
        print(f"✅ 成功访问登录页面: {driver.current_url}")
        print(f"页面标题: {driver.title}")
        
        # 查找手机号输入框
        try:
            phone_input = WebDriverWait(driver, 10).until(
                EC.presence_of_element_located((By.CSS_SELECTOR, "input[type='tel'], input[placeholder*='手机号']"))
            )
            print("✅ 找到手机号输入框")
            
            # 填写手机号
            phone_input.clear()
            phone_input.send_keys("13800138000")
            print("✅ 已填写手机号: 13800138000")
            
        except TimeoutException:
            print("❌ 找不到手机号输入框")
            return False
            
        # 查找验证码输入框
        try:
            code_input = WebDriverWait(driver, 10).until(
                EC.presence_of_element_located((By.CSS_SELECTOR, "input[placeholder*='验证码']"))
            )
            print("✅ 找到验证码输入框")
            
            # 填写验证码
            code_input.clear()
            code_input.send_keys("123456")
            print("✅ 已填写验证码: 123456")
            
        except TimeoutException:
            print("❌ 找不到验证码输入框")
            return False
            
        # 查找登录按钮
        try:
            login_button = WebDriverWait(driver, 10).until(
                EC.element_to_be_clickable((By.CSS_SELECTOR, "button[type='submit'], button:contains('登录'), .login-btn"))
            )
            print(f"✅ 找到登录按钮: {login_button.text}")
            
            # 点击登录
            login_button.click()
            print("✅ 已点击登录按钮")
            
            # 等待响应
            time.sleep(3)
            
            # 检查登录结果
            if "#/login" not in driver.current_url:
                print(f"✅ 登录成功！跳转到: {driver.current_url}")
                return True
            else:
                print("⚠️ 仍在登录页面，检查错误信息...")
                
                # 检查错误提示
                try:
                    error_msg = driver.find_element(By.CSS_SELECTOR, ".error-message, .el-message--error")
                    print(f"❌ 登录失败: {error_msg.text}")
                except:
                    print("❌ 登录失败，无错误提示")
                return False
                
        except TimeoutException:
            print("❌ 找不到登录按钮")
            return False
            
    except Exception as e:
        print(f"❌ 测试失败: {str(e)}")
        return False
    finally:
        driver.quit()

if __name__ == "__main__":
    print("开始直接登录测试...")
    success = test_direct_login()
    if success:
        print("🎉 直接登录测试通过！")
    else:
        print("💥 直接登录测试失败")