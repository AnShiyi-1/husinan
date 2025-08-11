import axios from 'axios';

const testLogin = async () => {
  try {
    const response = await axios.post('http://localhost:3001/api/auth/login', {
      username: 'testuser',
      password: 'password123'
    });
    
    console.log('登录成功:', response.data);
  } catch (error) {
    console.error('登录失败:', error.response?.data || error.message);
  }
};

testLogin();