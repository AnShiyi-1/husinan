/**
 * 用户注册数据传输对象
 */

/**
 * 手机号注册请求DTO
 * @typedef {Object} RegisterWithPhoneDTO
 * @property {string} phone.required - 手机号
 * @property {string} code.required - 验证码
 * @property {string} username - 用户名（可选）
 * @property {string} password - 密码（可选）
 */

/**
 * 注册响应DTO
 * @typedef {Object} RegisterResponseDTO
 * @property {boolean} success - 是否成功
 * @property {string} message - 响应消息
 * @property {Object} user - 用户信息
 * @property {string} token - 访问令牌
 */

/**
 * 验证手机号DTO
 * @typedef {Object} VerifyPhoneDTO
 * @property {string} phone.required - 手机号
 */

/**
 * 验证用户名DTO
 * @typedef {Object} VerifyUsernameDTO
 * @property {string} username.required - 用户名
 */

export const RegisterSchemas = {
  RegisterWithPhoneDTO: {
    type: 'object',
    required: ['phone', 'code'],
    properties: {
      phone: {
        type: 'string',
        pattern: '^1[3-9]\\d{9}$',
        description: '手机号'
      },
      code: {
        type: 'string',
        pattern: '^\\d{6}$',
        description: '6位验证码'
      },
      username: {
        type: 'string',
        minLength: 2,
        maxLength: 20,
        description: '用户名（可选，默认为用户+手机号后4位）'
      },
      password: {
        type: 'string',
        minLength: 6,
        description: '密码（可选）'
      }
    }
  },

  VerifyPhoneDTO: {
    type: 'object',
    required: ['phone'],
    properties: {
      phone: {
        type: 'string',
        pattern: '^1[3-9]\\d{9}$',
        description: '手机号'
      }
    }
  },

  VerifyUsernameDTO: {
    type: 'object',
    required: ['username'],
    properties: {
      username: {
        type: 'string',
        minLength: 2,
        maxLength: 20,
        pattern: '^[a-zA-Z0-9_\\u4e00-\\u9fa5]+$',
        description: '用户名'
      }
    }
  }
};