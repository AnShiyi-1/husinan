import bcrypt from 'bcryptjs';

const hashedPassword = '$2b$10$K.Nej6Vw57atKAgL5V07eutqW8IO7bAkLeCvX7KOHgn/t3plCWm1S';
const testPassword = 'password123';

const isMatch = await bcrypt.compare(testPassword, hashedPassword);
console.log('密码匹配结果:', isMatch);