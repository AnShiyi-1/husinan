// 直接测试后端登录功能
import axios from 'axios';

async function testBackendLogin() {
  try {
    console.log('开始测试后端登录功能...');
    
    // 登录凭据
    const credentials = {
      username: 'testuser',
      password: 'password123'
    };
    
    // 发送登录请求
    const response = await axios.post('http://localhost:3001/api/auth/login', credentials);
    
    console.log('登录响应:', response.data);
    console.log('用户信息:', response.data.user);
    console.log('访问令牌:', response.data.token);
    
    // 验证响应数据
    if (response.data.user && response.data.token) {
      console.log('后端登录测试成功!');
      return true;
    } else {
      console.error('后端登录测试失败: 响应数据不完整');
      return false;
    }
  } catch (error) {
    console.error('后端登录测试失败:', error.response?.data || error.message);
    return false;
  }
}

// 运行测试
console.log('运行后端登录测试...');
testBackendLogin().then(success => {
  if (success) {
    console.log('测试完成，后端登录功能正常');
  } else {
    console.log('测试完成，后端登录功能异常');
  }
});