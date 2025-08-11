import axios from 'axios';

const debugLogin = async () => {
  try {
    // 先检查tempStorage状态
    const storageResponse = await axios.get('http://localhost:3001/api/auth/debug-temp-storage');
    console.log('服务器tempStorage状态:', JSON.stringify(storageResponse.data, null, 2));
    
    // 检查用户是否存在
    const users = storageResponse.data.tempStorage.users;
    const targetUser = users.find(u => u.username === '123');
    console.log('查找用户123:', targetUser ? '找到' : '未找到');
    
    if (targetUser) {
      console.log('用户详情:', JSON.stringify(targetUser, null, 2));
    }
    
    // 尝试登录
    console.log('尝试登录...');
    const loginResponse = await axios.post('http://localhost:3001/api/auth/login', {
      username: '123',
      password: 'password123'
    });
    
    console.log('登录成功:', loginResponse.data);
  } catch (error) {
    console.error('登录失败:', error.response?.data || error.message);
  }
};

debugLogin();