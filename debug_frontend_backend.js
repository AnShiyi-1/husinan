import axios from 'axios';
import fs from 'fs';

// 模拟前端发送登录请求
async function testLogin() {
  try {
    console.log('开始测试登录流程...');
    
    // 读取临时存储文件内容
    const tempStorage = JSON.parse(fs.readFileSync('./server/temp_storage.json', 'utf8'));
    console.log('临时存储中的用户列表:', tempStorage.users);
    
    // 查找testuser用户
    const testUser = tempStorage.users.find(user => user.username === 'testuser');
    console.log('找到的测试用户:', testUser);
    
    if (!testUser) {
      console.log('未找到testuser用户');
      return;
    }
    
    // 模拟前端发送登录请求
    const loginData = {
      username: 'testuser',
      password: 'password123'
    };
    
    console.log('发送登录请求数据:', loginData);
    
    const response = await axios.post('http://localhost:3001/api/auth/login', loginData);
    console.log('登录响应:', response.data);
    
    console.log('登录测试成功!');
  } catch (error) {
    console.error('登录测试失败:', error.response?.data || error.message);
  }
}

testLogin();