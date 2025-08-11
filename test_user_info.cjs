const axios = require('axios');

// 从之前的测试中获取一个有效的token
const token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIxNzU0MDY2NzEzNTY3IiwidXNlcm5hbWUiOiJuZXd1c2VyMTc1NDA2NjcxMzI0NSIsImlhdCI6MTczNTc0MjExMywiZXhwIjoxNzM1ODI4NTEzfQ.wJi54R0v4Q4Z8b4Z8Z8Z8Z8Z8Z8Z8Z8Z8Z8Z8Z8Z8Z8';

async function testUserInfo() {
  try {
    const response = await axios.get('http://localhost:3001/api/auth/me', {
      headers: {
        'Authorization': `Bearer ${token}`
      }
    });
    
    console.log('用户信息获取成功:');
    console.log(JSON.stringify(response.data, null, 2));
  } catch (error) {
    console.error('获取用户信息失败:');
    if (error.response) {
      console.error('状态码:', error.response.status);
      console.error('响应数据:', error.response.data);
    } else {
      console.error('错误:', error.message);
    }
  }
}

testUserInfo();