const axios = require('axios');

// 配置axios基础URL
const API_BASE_URL = 'http://localhost:3001/api';
axios.defaults.baseURL = API_BASE_URL;

// 测试前端登出重定向功能
async function testLogoutRedirect() {
  console.log('开始测试前端登出重定向功能...');
  
  try {
    // 1. 注册测试用户
    console.log('\n1. 注册测试用户...');
    const username = 'test' + (Date.now() % 100000);
    const password = 'test123456';
    
    const registerResponse = await axios.post('/auth/register', {
      username,
      password
    });
    
    console.log('✓ 注册成功');
    const token = registerResponse.data.token;
    
    // 2. 验证token有效性
    console.log('\n2. 验证token有效性...');
    const authResponse = await axios.get('/auth/me', {
      headers: { Authorization: `Bearer ${token}` }
    });
    
    console.log('✓ Token有效，用户信息:', authResponse.data.username);
    
    // 3. 测试登出API
    console.log('\n3. 测试登出API...');
    await axios.post('/auth/logout', {}, {
      headers: { Authorization: `Bearer ${token}` }
    });
    
    console.log('✓ 登出API调用成功');
    
    // 4. 等待一段时间确保登出处理完成
    console.log('\n4. 等待服务器处理登出请求...');
    await new Promise(resolve => setTimeout(resolve, 2000));
    
    // 5. 验证token已失效
    console.log('\n5. 验证token已失效...');
    try {
      await axios.get('/auth/me', {
        headers: { Authorization: `Bearer ${token}` }
      });
      console.log('✗ 错误：Token仍然有效');
    } catch (error) {
      if (error.response && error.response.status === 403) {
        console.log('✓ Token已失效，登出功能正常');
      } else {
        console.log('✗ 错误：意外的响应状态', error.response?.status);
        if (error.response) {
          console.log('响应数据:', error.response.data);
        }
      }
    }
    
    console.log('\n🎉 前端登出重定向测试完成!');
  } catch (error) {
    console.error('✗ 测试过程中出现错误:', error.message);
    if (error.response) {
      console.error('响应状态:', error.response.status);
      console.error('响应数据:', error.response.data);
    }
  }
}

// 运行测试
testLogoutRedirect();