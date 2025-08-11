import { tempStorage } from './server/routes/auth.js';

console.log('tempStorage:', tempStorage);

// 模拟登录逻辑中的用户查找
const username = '123';
const user = tempStorage.users.find(item => item.username === username);

console.log('查找用户:', username);
console.log('找到的用户:', user);

if (user) {
  console.log('用户存在');
} else {
  console.log('用户不存在');
}