import fs from 'fs';
import path from 'path';
import bcrypt from 'bcryptjs';

const STORAGE_FILE = path.join(process.cwd(), 'server', 'temp_storage.json');

// 加载临时存储
const loadTempStorage = () => {
  try {
    if (fs.existsSync(STORAGE_FILE)) {
      const data = fs.readFileSync(STORAGE_FILE, 'utf8');
      return JSON.parse(data);
    }
  } catch (error) {
    console.error('加载临时存储失败:', error);
  }
  return {
    users: [],
    verificationCodes: []
  };
};

// 模拟后端登录逻辑
const simulateBackendLogin = async (username, password) => {
  console.log('模拟后端登录逻辑');
  console.log('输入用户名:', username);
  console.log('输入密码:', password);
  
  // 重新加载tempStorage
  let tempStorage = loadTempStorage();
  console.log('临时存储内容:', JSON.stringify(tempStorage, null, 2));
  
  // 查找用户
  console.log('\n开始查找用户...');
  const user = tempStorage.users.find(item => {
    console.log(`比较: "${item.username}" === "${username}" ? ${item.username === username}`);
    return item.username === username;
  });
  
  console.log('查找结果:', user);
  
  if (!user) {
    console.log('用户不存在');
    return { error: '用户不存在' };
  }
  
  // 验证密码
  console.log('\n开始验证密码...');
  console.log('存储的密码哈希:', user.password);
  
  const isPasswordValid = await bcrypt.compare(password, user.password);
  console.log('密码验证结果:', isPasswordValid);
  
  if (!isPasswordValid) {
    console.log('密码错误');
    return { error: '密码错误' };
  }
  
  console.log('登录成功');
  return { 
    user: {
      id: user.id,
      username: user.username,
      avatar: user.avatar,
      createdAt: user.created_at
    }
  };
};

// 运行测试
const testUsername = 'testuser';
const testPassword = 'password123';

simulateBackendLogin(testUsername, testPassword)
  .then(result => {
    console.log('\n最终结果:');
    console.log(JSON.stringify(result, null, 2));
  })
  .catch(error => {
    console.error('测试过程中出错:', error);
  });