#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
调试登录页面元素
"""

import time
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

# 创建浏览器实例
driver = webdriver.Chrome()
wait = WebDriverWait(driver, 10)

try:
    print("开始调试登录页面...")
    
    # 访问登录页面
    driver.get('http://localhost:3000/#/login')
    print(f"当前URL: {driver.current_url}")
    
    # 等待页面加载
    time.sleep(3)
    
    # 打印页面标题
    print(f"页面标题: {driver.title}")
    
    # 查找所有输入框
    inputs = driver.find_elements(By.TAG_NAME, 'input')
    print(f"找到 {len(inputs)} 个输入框:")
    for i, inp in enumerate(inputs):
        print(f"  输入框 {i+1}: type={inp.get_attribute('type')}, placeholder={inp.get_attribute('placeholder')}, name={inp.get_attribute('name')}, id={inp.get_attribute('id')}")
    
    # 查找所有按钮
    buttons = driver.find_elements(By.TAG_NAME, 'button')
    print(f"找到 {len(buttons)} 个按钮:")
    for i, btn in enumerate(buttons):
        print(f"  按钮 {i+1}: text={btn.text}, type={btn.get_attribute('type')}, class={btn.get_attribute('class')}")
    
    # 查找所有表单
    forms = driver.find_elements(By.TAG_NAME, 'form')
    print(f"找到 {len(forms)} 个表单")
    
    # 查找包含登录关键字的元素
    login_elements = driver.find_elements(By.XPATH, "//*[contains(text(), '登录') or contains(text(), 'login') or contains(@placeholder, '登录')]")
    print(f"找到 {len(login_elements)} 个登录相关元素")
    
    # 打印页面源码的前1000字符
    source = driver.page_source
    print("页面源码片段:")
    print(source[:1000])
    
    print("调试完成")
    
except Exception as e:
    print(f"调试出错: {str(e)}")
    
finally:
    driver.quit()