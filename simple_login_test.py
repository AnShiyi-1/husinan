#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
简化版登录测试 - 直接访问登录页面并填写表单
"""

import time
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.common.exceptions import TimeoutException, NoSuchElementException

def test_simple_login():
    """简化版登录测试"""
    driver = webdriver.Chrome()
    driver.maximize_window()
    
    try:
        # 直接访问登录页面
        login_url = "http://localhost:3000/#/login"
        print(f"正在访问: {login_url}")
        driver.get(login_url)
        
        # 等待页面加载
        time.sleep(3)
        
        # 打印当前URL和标题
        print(f"当前URL: {driver.current_url}")
        print(f"页面标题: {driver.title}")
        
        # 查找所有输入框
        inputs = driver.find_elements(By.TAG_NAME, "input")
        print(f"找到 {len(inputs)} 个输入框")
        for i, inp in enumerate(inputs):
            print(f"  输入框 {i+1}: type={inp.get_attribute('type')}, placeholder={inp.get_attribute('placeholder')}, name={inp.get_attribute('name')}")
        
        # 查找用户名和密码输入框
        try:
            username_input = WebDriverWait(driver, 10).until(
                EC.presence_of_element_located((By.CSS_SELECTOR, "input[type='text'], input[name='username'], input[placeholder*='用户名'], input[placeholder*='账号']"))
            )
            print(f"找到用户名输入框: {username_input.get_attribute('outerHTML')}")
            
            password_input = driver.find_element(By.CSS_SELECTOR, "input[type='password'], input[name='password'], input[placeholder*='密码']")
            print(f"找到密码输入框: {password_input.get_attribute('outerHTML')}")
            
            # 填写账号密码
            username_input.clear()
            username_input.send_keys("test_user")
            print("已填写用户名")
            
            password_input.clear()
            password_input.send_keys("test_password")
            print("已填写密码")
            
            # 查找登录按钮
            login_button = driver.find_element(By.CSS_SELECTOR, "button[type='submit'], .login-btn, button:contains('登录'), button:contains('Login')")
            print(f"找到登录按钮: {login_button.text}")
            
            # 点击登录
            login_button.click()
            print("已点击登录按钮")
            
            # 等待页面跳转
            time.sleep(3)
            print(f"登录后URL: {driver.current_url}")
            
            return True
            
        except TimeoutException:
            print("超时: 找不到登录表单元素")
            # 打印页面源码
            print("页面源码:")
            print(driver.page_source[:1000])
            return False
            
    except Exception as e:
        print(f"测试失败: {str(e)}")
        return False
    finally:
        driver.quit()

if __name__ == "__main__":
    print("开始简化版登录测试...")
    success = test_simple_login()
    if success:
        print("✅ 简化版登录测试通过")
    else:
        print("❌ 简化版登录测试失败")