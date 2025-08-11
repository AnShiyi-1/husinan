import axios from 'axios';

const API_BASE_URL = 'http://localhost:3001/api';

const testRegisterAndLogin = async () => {
  const testUsername = `user${Date.now().toString().slice(-6)}`; // 使用较短的用户名
  const testPassword = 'password123';
  
  console.log('开始测试注册和登录流程...');
  console.log('测试用户名:', testUsername);
  
  try {
    // 1. 注册用户
    console.log('\n1. 注册用户...');
    const registerResponse = await axios.post(`${API_BASE_URL}/auth/register`, {
      username: testUsername,
      password: testPassword
    });
    
    console.log('注册成功:', registerResponse.data.message);
    
    // 2. 登录用户
    console.log('\n2. 登录用户...');
    const loginResponse = await axios.post(`${API_BASE_URL}/auth/login`, {
      username: testUsername,
      password: testPassword
    });
    
    console.log('登录成功:', loginResponse.data.user.username);
    console.log('Token获取成功:', !!loginResponse.data.token);
    
    console.log('\n✅ 测试完成 - 注册和登录功能正常工作');
  } catch (error) {
    console.error('❌ 测试失败:', error.response?.data || error.message);
  }
};

testRegisterAndLogin();