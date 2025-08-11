// 测试登录API
import axios from 'axios';

async function testLogin() {
  try {
    console.log('测试登录API...');
    
    const response = await axios.post('http://localhost:3000/api/auth/login', {
      username: 'testuser',
      password: '123456'
    });
    
    console.log('登录成功:', response.data);
  } catch (error) {
    console.error('登录失败:', error.response?.data || error.message);
    if (error.response?.data?.error) {
      console.error('错误详情:', error.response.data.error);
    }
  }
}

testLogin();