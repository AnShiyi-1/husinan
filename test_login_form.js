// 测试前端登录表单数据

// 模拟Vue响应式数据
let loginForm = {
  username: '',
  password: '',
  remember: false
};

// 模拟设置表单数据
function setLoginForm(username, password, remember) {
  loginForm.username = username;
  loginForm.password = password;
  loginForm.remember = remember;
  
  console.log('登录表单数据已设置:', loginForm);
  return loginForm;
}

// 测试设置表单数据
const testData = setLoginForm('testuser', 'password123', false);
console.log('测试数据:', testData);

// 验证数据是否正确
if (testData.username === 'testuser' && testData.password === 'password123') {
  console.log('表单数据设置正确');
} else {
  console.log('表单数据设置错误');
}