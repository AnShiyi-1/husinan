import { createRequire } from 'module';
const require = createRequire(import.meta.url);
const nodemailer = require('nodemailer');

// 从环境变量获取邮件配置
const emailConfig = {
  host: process.env.EMAIL_HOST || 'smtp.qq.com',
  port: parseInt(process.env.EMAIL_PORT) || 587,
  secure: process.env.EMAIL_SECURE === 'true',
  auth: {
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_PASS
  }
};

// 创建邮件传输器
let transporter = null;

function createTransporter() {
  if (!emailConfig.auth.user || !emailConfig.auth.pass) {
    console.log('⚠️  邮箱配置不完整，将使用演示模式');
    return null;
  }

  try {
    const transporter = nodemailer.createTransporter(emailConfig);
    console.log('✅ 邮件传输器创建成功');
    return transporter;
  } catch (error) {
    console.error('创建邮件传输器失败:', error.message);
    return null;
  }
}

// 初始化传输器
function initTransporter() {
  if (!transporter) {
    transporter = createTransporter();
  }
  return transporter;
}

// 发送邮件函数
async function sendEmail(to, subject, text, html = null) {
  // 确保传输器已初始化
  if (!transporter) {
    transporter = initTransporter();
  }

  // 如果没有配置真实邮箱，使用演示模式
  if (!transporter) {
    const demoCode = Math.random().toString().slice(2, 8);
    console.log(`📧 演示模式 - 邮箱验证码：${to} -> ${demoCode}`);
    return { 
      success: true, 
      demo: true, 
      code: demoCode,
      message: '演示模式：验证码已打印到控制台'
    };
  }

  const mailOptions = {
    from: emailConfig.auth.user,
    to,
    subject,
    text,
    html
  };

  try {
    const result = await transporter.sendMail(mailOptions);
    console.log('📧 邮件发送成功:', result.messageId);
    return { success: true, messageId: result.messageId };
  } catch (error) {
    console.error('邮件发送失败:', error.message);
    return { success: false, error: error.message };
  }
}

// 发送验证码邮件
async function sendVerificationCode(email, code) {
  return sendEmail(
    email,
    '邮箱验证码 - 情感画板',
    `您的验证码是：${code}，有效期10分钟。`,
    `<h3>邮箱验证码</h3><p>您的验证码是：<strong>${code}</strong></p><p>有效期：10分钟</p>`
  );
}

// 发送重置密码邮件
async function sendResetPasswordEmail(email, resetUrl) {
  return sendEmail(
    email,
    '重置密码 - 情感画板',
    `请点击以下链接重置密码：${resetUrl}`,
    `<h3>重置密码</h3><p>请点击以下链接重置密码：</p><p><a href="${resetUrl}">${resetUrl}</a></p>`
  );
}

export {
  sendEmail,
  sendVerificationCode,
  sendResetPasswordEmail,
  initTransporter
};