import axios from 'axios';

const testLogin = async () => {
  try {
    // 确保发送正确的JSON格式
    const response = await axios.post('http://localhost:3001/api/auth/login', {
      username: 'testuser',
      password: 'password123'
    }, {
      headers: {
        'Content-Type': 'application/json'
      }
    });
    
    console.log('登录成功:', response.data);
  } catch (error) {
    console.error('登录失败:', error.response?.data || error.message);
  }
};

testLogin();