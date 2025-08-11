#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
详细调试登录页面的脚本
用于检查实际的登录表单元素结构
"""

import time
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.common.exceptions import TimeoutException, NoSuchElementException

# 创建浏览器实例
driver = webdriver.Chrome()
wait = WebDriverWait(driver, 10)

# 基础URL
base_url = "http://localhost:3000"

try:
    print("=== 开始详细调试登录页面 ===")
    
    # 访问登录页面
    driver.get(f"{base_url}/#/login")
    print(f"已访问: {driver.current_url}")
    
    # 等待页面加载
    time.sleep(3)
    
    # 打印页面标题
    print(f"页面标题: {driver.title}")
    
    # 查找所有输入框
    print("\n=== 查找所有输入框 ===")
    inputs = driver.find_elements(By.TAG_NAME, "input")
    for i, input_elem in enumerate(inputs):
        input_type = input_elem.get_attribute("type") or "text"
        placeholder = input_elem.get_attribute("placeholder") or "无placeholder"
        input_id = input_elem.get_attribute("id") or "无id"
        input_name = input_elem.get_attribute("name") or "无name"
        input_class = input_elem.get_attribute("class") or "无class"
        
        print(f"输入框 {i+1}:")
        print(f"  类型: {input_type}")
        print(f"  placeholder: {placeholder}")
        print(f"  id: {input_id}")
        print(f"  name: {input_name}")
        print(f"  class: {input_class}")
        print(f"  元素文本: {input_elem.get_attribute('value')}")
        
        # 尝试点击输入框
        try:
            input_elem.click()
            print(f"  ✅ 可点击")
        except Exception as e:
            print(f"  ❌ 不可点击: {str(e)}")
    
    # 查找所有按钮
    print("\n=== 查找所有按钮 ===")
    buttons = driver.find_elements(By.TAG_NAME, "button")
    for i, button in enumerate(buttons):
        button_text = button.text or "无文本"
        button_type = button.get_attribute("type") or "无type"
        button_id = button.get_attribute("id") or "无id"
        button_class = button.get_attribute("class") or "无class"
        
        print(f"按钮 {i+1}:")
        print(f"  文本: {button_text}")
        print(f"  type: {button_type}")
        print(f"  id: {button_id}")
        print(f"  class: {button_class}")
        
        # 检查是否可点击
        try:
            button.click()
            print(f"  ✅ 可点击")
            driver.back()  # 返回登录页面
            time.sleep(2)
        except Exception as e:
            print(f"  ❌ 不可点击: {str(e)}")
    
    # 查找表单
    print("\n=== 查找表单 ===")
    forms = driver.find_elements(By.TAG_NAME, "form")
    for i, form in enumerate(forms):
        form_action = form.get_attribute("action") or "无action"
        form_method = form.get_attribute("method") or "无method"
        form_class = form.get_attribute("class") or "无class"
        
        print(f"表单 {i+1}:")
        print(f"  action: {form_action}")
        print(f"  method: {form_method}")
        print(f"  class: {form_class}")
        
        # 打印表单内部HTML
        print(f"  表单HTML: {form.get_attribute('outerHTML')[:200]}...")
    
    # 尝试定位用户名输入框
    print("\n=== 尝试定位用户名输入框 ===")
    username_selectors = [
        '//input[@type="text"]',
        '//input[@placeholder="用户名"]',
        '//input[@placeholder="用户名/邮箱"]',
        '//input[@id="username"]',
        '//input[@name="username"]',
        '//input[@id="user"]',
        '//input[@name="user"]'
    ]
    
    for selector in username_selectors:
        try:
            username_input = wait.until(EC.presence_of_element_located((By.XPATH, selector)))
            print(f"✅ 找到用户名输入框: {selector}")
            print(f"  元素: {username_input}")
            break
        except TimeoutException:
            print(f"❌ 未找到: {selector}")
    
    # 尝试定位密码输入框
    print("\n=== 尝试定位密码输入框 ===")
    password_selectors = [
        '//input[@type="password"]',
        '//input[@placeholder="密码"]',
        '//input[@id="password"]',
        '//input[@name="password"]',
        '//input[@id="pwd"]',
        '//input[@name="pwd"]'
    ]
    
    for selector in password_selectors:
        try:
            password_input = wait.until(EC.presence_of_element_located((By.XPATH, selector)))
            print(f"✅ 找到密码输入框: {selector}")
            print(f"  元素: {password_input}")
            break
        except TimeoutException:
            print(f"❌ 未找到: {selector}")
    
    # 尝试定位登录按钮
    print("\n=== 尝试定位登录按钮 ===")
    login_button_selectors = [
        '//button[contains(text(), "登录")]',
        '//button[@type="submit"]',
        '//button[contains(@class, "login")]',
        '//button[contains(@class, "btn-primary")]',
        '//button[@id="login-button"]',
        '//button[@id="login-btn"]'
    ]
    
    for selector in login_button_selectors:
        try:
            login_button = wait.until(EC.presence_of_element_located((By.XPATH, selector)))
            print(f"✅ 找到登录按钮: {selector}")
            print(f"  元素: {login_button}")
            print(f"  文本: {login_button.text}")
            break
        except TimeoutException:
            print(f"❌ 未找到: {selector}")
    
    # 打印页面完整HTML
    print("\n=== 页面完整HTML ===")
    html = driver.page_source
    print(html[:2000])  # 打印前2000字符
    
    print("\n=== 调试完成 ===")
    
except Exception as e:
    print(f"调试过程中发生错误: {str(e)}")
    import traceback
    traceback.print_exc()
    
finally:
    driver.quit()