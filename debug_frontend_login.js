// 模拟前端登录流程

// 检查环境变量
console.log('VITE_API_BASE_URL:', import.meta.env.VITE_API_BASE_URL);

// 模拟登录表单数据
const loginForm = {
  username: 'testuser',
  password: 'password123',
  remember: false
};

console.log('登录表单数据:', loginForm);

// 模拟API调用
async function testLogin() {
  try {
    const response = await fetch(import.meta.env.VITE_API_BASE_URL + '/auth/login', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(loginForm)
    });
    
    const data = await response.json();
    console.log('登录响应:', data);
    
    if (data.token) {
      console.log('登录成功!');
      // 模拟存储token
      localStorage.setItem('token', data.token);
      console.log('Token已存储');
    } else {
      console.log('登录失败:', data.error || '未知错误');
    }
  } catch (error) {
    console.error('登录请求失败:', error);
  }
}

testLogin();