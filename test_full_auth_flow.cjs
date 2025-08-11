const axios = require('axios');

// 创建axios实例
const api = axios.create({
  baseURL: 'http://localhost:3001/api'
});

async function testFullAuthFlow() {
  console.log('开始测试完整认证流程...');
  
  try {
    // 1. 测试注册新用户
    console.log('\n1. 测试用户注册...');
    // 确保用户名长度在2-20位之间
    const username = 'testuser' + (Date.now() % 100000);
    const registerResponse = await api.post('/auth/register', {
      username: username,
      password: 'TestPass123!'
    });
    
    console.log('注册成功:', registerResponse.data);
    const token = registerResponse.data.token;
    
    // 2. 测试使用有效token访问受保护的API
    console.log('\n2. 测试使用有效token访问受保护的API...');
    try {
      const artworksResponse = await api.get('/artworks', {
        headers: { Authorization: `Bearer ${token}` }
      });
      console.log('成功访问受保护的API，作品数量:', artworksResponse.data.length);
    } catch (error) {
      console.error('访问受保护的API失败:', error.response?.data || error.message);
      return;
    }
    
    // 3. 测试使用无效token访问受保护的API
    console.log('\n3. 测试使用无效token访问受保护的API...');
    try {
      await api.get('/artworks', {
        headers: { Authorization: 'Bearer invalid_token_here' }
      });
      console.log('警告: 使用无效token访问受保护的API竟然成功了!');
    } catch (error) {
      if (error.response?.status === 403) {
        console.log('正确拒绝了无效token的访问');
      } else {
        console.error('使用无效token访问时出现意外错误:', error.response?.data || error.message);
      }
    }
    
    // 4. 测试无token访问受保护的API
    console.log('\n4. 测试无token访问受保护的API...');
    try {
      await api.get('/artworks');
      console.log('警告: 无token访问受保护的API竟然成功了!');
    } catch (error) {
      if (error.response?.status === 401) {
        console.log('正确拒绝了无token的访问');
      } else {
        console.error('无token访问时出现意外错误:', error.response?.data || error.message);
      }
    }
    
    console.log('\n所有测试完成!');
  } catch (error) {
    console.error('测试过程中出现错误:', error.response?.data || error.message);
  }
}

testFullAuthFlow();