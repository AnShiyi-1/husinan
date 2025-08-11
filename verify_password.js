import bcrypt from 'bcryptjs';

const hashedPassword = '$2b$10$T5e6Gur8BpcsvqYDLs3dXedGnpFeMMvBLuKf.lrp/6cVmXFIJhqti';
const testPassword = 'password123';

const isMatch = await bcrypt.compare(testPassword, hashedPassword);
console.log('密码匹配结果:', isMatch);