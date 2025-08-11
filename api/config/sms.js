import twilio from 'twilio'
import dotenv from 'dotenv'

dotenv.config()

const accountSid = process.env.TWILIO_ACCOUNT_SID
const authToken = process.env.TWILIO_AUTH_TOKEN
const fromPhone = process.env.TWILIO_PHONE_NUMBER

if (!accountSid || !authToken || !fromPhone) {
  console.warn('Twilio配置不完整，将使用演示模式')
}

const client = accountSid && authToken ? twilio(accountSid, authToken) : null

/**
 * 发送短信验证码
 * @param {string} toPhone - 目标手机号
 * @param {string} code - 验证码
 * @returns {Promise<boolean>} - 发送成功返回true
 */
export const sendSMS = async (toPhone, code) => {
  try {
    if (!client) {
      // 演示模式下立即返回，不打印日志减少延迟
      console.log(`验证码已生成：${code}`)
      return true
    }

    // 生产环境异步发送，不阻塞响应
    const message = await client.messages.create({
      body: `【情绪画布】您的验证码是：${code}，5分钟内有效。如非本人操作请忽略。`,
      from: fromPhone,
      to: toPhone
    })

    console.log('短信发送成功:', message.sid)
    return true
  } catch (error) {
    console.error('短信发送失败:', error)
    return false
  }
}

/**
 * 生成随机验证码
 * @param {number} length - 验证码长度
 * @returns {string} - 随机验证码
 */
export const generateCode = (length = 6) => {
  const chars = '0123456789'
  let result = ''
  for (let i = 0; i < length; i++) {
    result += chars.charAt(Math.floor(Math.random() * chars.length))
  }
  return result
}