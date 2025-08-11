import fs from 'fs';
import path from 'path';

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

const tempStorage = loadTempStorage();

console.log('临时存储内容:');
console.log(JSON.stringify(tempStorage, null, 2));

// 模拟查找用户
const usernameToFind = 'testuser';
console.log(`\n查找用户名: ${usernameToFind}`);

const foundUser = tempStorage.users.find(item => {
  console.log(`比较: "${item.username}" === "${usernameToFind}" ? ${item.username === usernameToFind}`);
  return item.username === usernameToFind;
});

console.log('\n查找结果:');
console.log(foundUser);