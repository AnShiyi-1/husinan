import axios from 'axios';

async function testLoginResponse() {
  try {
    const response = await axios.post('http://localhost:3001/api/auth/login', {
      username: 'testuser',
      password: 'password123'
    });
    
    console.log('登录响应数据结构:');
    console.log(JSON.stringify(response.data, null, 2));
    
    console.log('\n用户信息:');
    console.log('user:', response.data.user);
    console.log('token:', response.data.token);
    
    console.log('\n用户对象属性:');
    if (response.data.user) {
      console.log('id:', response.data.user.id);
      console.log('username:', response.data.user.username);
      console.log('avatar:', response.data.user.avatar);
      console.log('createdAt:', response.data.user.createdAt);
    }
  } catch (error) {
    console.error('登录测试失败:', error.message);
    if (error.response) {
      console.error('错误响应:', error.response.data);
    }
  }
}

testLoginResponse();