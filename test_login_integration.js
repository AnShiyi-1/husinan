// 测试前端和后端登录功能的集成

// 模拟前端登录表单数据
const loginForm = {
  username: 'testuser',
  password: 'password123',
  remember: false
};

// 模拟API调用
async function testLogin() {
  try {
    console.log('开始测试登录功能...');
    
    // 模拟发送登录请求到后端
    const response = await fetch('http://localhost:3001/api/auth/login', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(loginForm)
    });
    
    const data = await response.json();
    
    if (response.ok) {
      console.log('登录成功:', data);
      console.log('用户信息:', data.user);
      console.log('访问令牌:', data.token);
      
      // 模拟存储令牌
      localStorage.setItem('token', data.token);
      console.log('令牌已存储到localStorage');
      
      return data;
    } else {
      console.error('登录失败:', data.error);
      return null;
    }
  } catch (error) {
    console.error('登录过程中发生错误:', error);
    }
}

// 运行测试
console.log('运行登录集成测试...');
testLogin().then(result => {
  if (result) {
    console.log('测试完成，登录成功');
  } else {
    console.log('测试完成，登录失败');
  }
});