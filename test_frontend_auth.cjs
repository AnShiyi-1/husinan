const axios = require('axios');

async function testFrontendAuth() {
  try {
    console.log('开始测试前端认证状态同步...');
    
    // 首先登录获取token
    const loginResponse = await axios.post('http://localhost:3001/api/auth/login', {
      username: '123',
      password: '123456'
    });
    
    const token = loginResponse.data.token;
    console.log('登录成功，获取到token');
    
    // 测试访问需要认证的API端点
    console.log('\n测试访问需要认证的API端点...');
    try {
      const protectedResponse = await axios.get('http://localhost:3001/api/artworks', {
        headers: {
          'Authorization': `Bearer ${token}`
        }
      });
      
      console.log('访问受保护的API端点成功');
    } catch (protectedError) {
      console.error('访问受保护的API端点失败:');
      if (protectedError.response) {
        console.error('状态码:', protectedError.response.status);
        console.error('响应数据:', protectedError.response.data);
      } else {
        console.error('错误:', protectedError.message);
      }
    }
    
    // 测试使用无效token访问
    console.log('\n测试使用无效token访问...');
    try {
      await axios.get('http://localhost:3001/api/artworks', {
        headers: {
          'Authorization': 'Bearer invalid-token'
        }
      });
      
      console.log('使用无效token访问竟然成功了（这不应该发生）');
    } catch (invalidTokenError) {
      if (invalidTokenError.response && invalidTokenError.response.status === 401) {
        console.log('使用无效token访问被正确拒绝');
      } else {
        console.error('使用无效token访问时出现意外错误:');
        if (invalidTokenError.response) {
          console.error('状态码:', invalidTokenError.response.status);
          console.error('响应数据:', invalidTokenError.response.data);
        } else {
          console.error('错误:', invalidTokenError.message);
        }
      }
    }
    
  } catch (error) {
    console.error('测试过程中出现错误:');
    if (error.response) {
      console.error('状态码:', error.response.status);
      console.error('响应数据:', error.response.data);
    } else {
      console.error('错误:', error.message);
    }
  }
}

testFrontendAuth();