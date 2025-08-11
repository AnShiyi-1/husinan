const axios = require('axios');

// 创建axios实例
const api = axios.create({
  baseURL: 'http://localhost:3001/api',
  timeout: 10000
});

async function runIntegrationTest() {
  console.log('开始执行集成测试...');
  
  try {
    // 1. 测试用户注册
    console.log('\n1. 测试用户注册...');
    const username = 'inttestuser' + (Date.now() % 10000);
    const password = 'TestPass123!';
    
    const registerResponse = await api.post('/auth/register', {
      username,
      password
    });
    
    console.log('✓ 注册成功');
    const token = registerResponse.data.token;
    
    // 2. 测试用户登录
    console.log('\n2. 测试用户登录...');
    const loginResponse = await api.post('/auth/login', {
      username,
      password
    });
    
    console.log('✓ 登录成功');
    const loginToken = loginResponse.data.token;
    
    // 3. 测试获取当前用户信息
    console.log('\n3. 测试获取当前用户信息...');
    const userResponse = await api.get('/auth/me', {
      headers: { Authorization: `Bearer ${loginToken}` }
    });
    
    console.log('✓ 成功获取用户信息');
    
    // 4. 测试使用登录token访问受保护的API
    console.log('\n4. 测试访问受保护的API...');
    const artworksResponse = await api.get('/artworks', {
      headers: { Authorization: `Bearer ${loginToken}` }
    });
    
    console.log('✓ 成功访问受保护的API');
    
    // 5. 测试登出功能
    console.log('\n5. 测试登出功能...');
    await api.post('/auth/logout', {}, {
      headers: { Authorization: `Bearer ${loginToken}` }
    });
    
    console.log('✓ 登出成功');
    
    console.log('\n🎉 所有集成测试通过!');
    
  } catch (error) {
    console.error('\n❌ 集成测试失败:', error.response?.data || error.message);
    process.exit(1);
  }
}

runIntegrationTest();