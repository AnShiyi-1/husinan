const axios = require('axios');

async function testLogin() {
  try {
    console.log('开始测试登录...');
    
    // 使用已知的用户名和密码进行登录测试
    const response = await axios.post('http://localhost:3001/api/auth/login', {
      username: '123',
      password: '123456'
    });
    
    console.log('登录成功!');
    console.log('响应数据:', JSON.stringify(response.data, null, 2));
    
    // 验证返回的用户信息
    if (response.data.user && response.data.token) {
      console.log('用户信息和令牌都已返回');
      
      // 测试使用令牌获取用户信息
      console.log('\n开始测试获取用户信息...');
      try {
        const userResponse = await axios.get('http://localhost:3001/api/auth/me', {
          headers: {
            'Authorization': `Bearer ${response.data.token}`
          }
        });
        
        console.log('获取用户信息成功:');
        console.log(JSON.stringify(userResponse.data, null, 2));
      } catch (userError) {
        console.error('获取用户信息失败:');
        if (userError.response) {
          console.error('状态码:', userError.response.status);
          console.error('响应数据:', userError.response.data);
        } else {
          console.error('错误:', userError.message);
        }
      }
    } else {
      console.log('登录响应缺少必要的用户信息或令牌');
    }
  } catch (error) {
    console.error('登录失败:');
    if (error.response) {
      console.error('状态码:', error.response.status);
      console.error('响应数据:', error.response.data);
    } else {
      console.error('错误:', error.message);
    }
  }
}

testLogin();