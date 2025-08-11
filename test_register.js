import axios from 'axios';

const testRegister = async () => {
  try {
    const response = await axios.post('http://localhost:3001/api/auth/register', {
      username: 'testuser',
      password: 'password123'
    }, {
      headers: {
        'Content-Type': 'application/json'
      }
    });
    
    console.log('注册成功:', response.data);
  } catch (error) {
    console.error('注册失败:', error.response?.data || error.message);
  }
};

testRegister();