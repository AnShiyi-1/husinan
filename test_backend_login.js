import axios from 'axios';

// 测试后端登录接口
async function testBackendLogin() {
  try {
    console.log('开始测试后端登录接口...');
    
    // 登录数据
    const loginData = {
      username: 'testuser',
      password: 'password123',
      remember: false
    };
    
    console.log('发送登录请求数据:', loginData);
    
    // 发送登录请求
    const response = await axios.post('http://localhost:3001/api/auth/login', loginData);
    
    console.log('登录响应状态:', response.status);
    console.log('登录响应数据:', response.data);
    
    if (response.data.user && response.data.token) {
      console.log('后端登录测试成功!');
      console.log('用户:', response.data.user.username);
      console.log('Token:', response.data.token.substring(0, 20) + '...');
    } else {
      console.log('后端登录测试失败:', response.data.error || '未知错误');
    }
  } catch (error) {
    console.error('后端登录测试失败:', error.response?.data || error.message);
  }
}

testBackendLogin();