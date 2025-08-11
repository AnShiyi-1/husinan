const axios = require('axios');

async function testAPI() {
  try {
    // 测试检查用户名端点
    console.log('测试检查用户名端点...');
    const checkResponse = await axios.post('http://localhost:3001/api/auth/check-username', {
      username: 'testuser'
    });
    console.log('检查用户名响应:', checkResponse.data);
    
    // 测试注册端点
    console.log('\n测试注册端点...');
    const registerResponse = await axios.post('http://localhost:3001/api/auth/register', {
      username: 'newuser' + Date.now(),
      password: 'password123'
    });
    console.log('注册响应:', registerResponse.data);
    
  } catch (error) {
    console.error('测试失败:', error.response ? error.response.data : error.message);
  }
}

testAPI();