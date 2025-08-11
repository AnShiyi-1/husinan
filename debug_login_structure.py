#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
详细调试登录页面结构
"""

import time
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

def debug_login_structure():
    """详细调试登录页面结构"""
    driver = webdriver.Chrome()
    driver.maximize_window()
    
    try:
        # 直接访问登录页面
        login_url = "http://localhost:3000/#/login"
        print(f"访问登录页面: {login_url}")
        driver.get(login_url)
        
        # 等待页面加载
        time.sleep(3)
        
        print(f"页面标题: {driver.title}")
        print(f"当前URL: {driver.current_url}")
        
        # 查找所有输入框
        inputs = driver.find_elements(By.TAG_NAME, "input")
        print(f"\n找到 {len(inputs)} 个输入框:")
        for i, inp in enumerate(inputs):
            print(f"  {i+1}. type='{inp.get_attribute('type')}' placeholder='{inp.get_attribute('placeholder')}' name='{inp.get_attribute('name')}' id='{inp.get_attribute('id')}'")
        
        # 查找所有按钮
        buttons = driver.find_elements(By.TAG_NAME, "button")
        print(f"\n找到 {len(buttons)} 个按钮:")
        for i, btn in enumerate(buttons):
            print(f"  {i+1}. text='{btn.text}' class='{btn.get_attribute('class')}' type='{btn.get_attribute('type')}'")
        
        # 查找所有表单元素
        forms = driver.find_elements(By.TAG_NAME, "form")
        print(f"\n找到 {len(forms)} 个表单:")
        for i, form in enumerate(forms):
            print(f"  {i+1}. action='{form.get_attribute('action')}' class='{form.get_attribute('class')}'")
        
        # 查找所有包含登录相关文本的元素
        login_elements = driver.find_elements(By.XPATH, "//*[contains(text(), '登录') or contains(text(), '登录')]")
        print(f"\n找到 {len(login_elements)} 个包含'登录'文本的元素:")
        for i, elem in enumerate(login_elements):
            print(f"  {i+1}. tag='{elem.tag_name}' text='{elem.text}' class='{elem.get_attribute('class')}'")
        
        # 打印页面源码的前1000字符
        print(f"\n页面源码前1000字符:")
        print(driver.page_source[:1000])
        
        return True
        
    except Exception as e:
        print(f"调试失败: {str(e)}")
        return False
    finally:
        driver.quit()

if __name__ == "__main__":
    debug_login_structure()