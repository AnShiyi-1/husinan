# QQ登录错误码100008解决方案

## 问题描述
QQ登录时显示："对不起，该网站尚未开通QQ帐号登录（错误码：100008）"

## 原因分析
错误码100008表示QQ互联后台配置不完整，主要有以下几个原因：

1. **应用未审核通过** - QQ互联应用处于待审核或审核未通过状态
2. **回调地址不匹配** - 实际回调地址与后台配置不一致
3. **应用权限未开通** - 网站登录权限未启用
4. **域名未备案** - 生产环境域名未备案或备案信息不一致

## 解决步骤

### 1. 检查应用审核状态
1. 登录 [QQ互联管理中心](https://connect.qq.com/manage.html)
2. 进入"应用管理" → "网站应用"
3. 查看应用状态：
   - **待审核**：等待腾讯审核（通常1-3个工作日）
   - **审核未通过**：根据驳回原因修改后重新提交
   - **已上线**：状态正常，继续下一步检查

### 2. 验证回调地址配置
1. 在应用详情页面，检查"回调地址"设置：
   ```
   开发环境：http://localhost:3001/api/oauth/qq/callback
   生产环境：https://yourdomain.com/api/oauth/qq/callback
   ```
2. 确保地址与代码中完全一致，包括：
   - 协议（http/https）
   - 域名/IP地址
   - 端口号
   - 路径大小写

### 3. 启用网站登录权限
1. 在应用详情页面，检查"权限列表"
2. 确保以下权限已启用：
   - [x] 获取用户基本信息
   - [x] 网站登录
   - [x] 获取用户QQ号码（可选）

### 4. 域名备案检查（生产环境）
1. 登录 [工信部备案系统](https://beian.miit.gov.cn)
2. 检查域名备案状态：
   - 备案必须完成
   - 备案主体必须与QQ互联应用主体一致
   - 域名必须能正常访问

### 5. 验证配置一致性

#### 前端配置检查
```bash
# 检查.env文件配置
VITE_QQ_CLIENT_ID=1112459080  # 必须与QQ互联一致
```

#### 后端配置检查
```bash
# 检查server/config/oauth.js
QQ_APP_ID=1112459080
QQ_APP_KEY=PA5tPHrwZX2UOJV9
QQ_CALLBACK_URL=http://localhost:3001/api/oauth/qq/callback
```

#### 路由配置检查
```javascript
// 检查src/router/index.js
const clientId = import.meta.env.VITE_QQ_CLIENT_ID || '1112459080'
const redirectUri = encodeURIComponent(window.location.origin + '/auth/callback')
```

## 开发环境特殊处理

### 本地测试配置
由于localhost无法备案，开发环境需要：

1. **使用已备案的测试域名**
   - 在hosts文件中映射：`127.0.0.1 test.yourdomain.com`
   - 将回调地址改为：`http://test.yourdomain.com:3001/api/oauth/qq/callback`

2. **使用内网穿透工具**
   - 安装ngrok：`ngrok http 3001`
   - 使用生成的https地址更新回调地址
   - 在QQ互联后台添加临时回调地址

### 测试验证步骤

1. **直接访问测试**
   ```
   在浏览器访问：
   https://graph.qq.com/oauth2.0/authorize?response_type=code&client_id=1112459080&redirect_uri=http://localhost:3001/api/oauth/qq/callback&scope=get_user_info
   ```

2. **检查返回信息**
   - 如果显示授权页面：配置正确
   - 如果显示100008错误：继续检查配置

## 常见问题快速排查

| 问题症状 | 检查要点 |
|---------|---------|
| 100008错误 | 应用状态、回调地址、域名备案 |
| 100001错误 | client_id是否正确 |
| redirect_uri错误 | 回调地址是否URL编码 |
| 权限不足 | 应用权限列表是否完整 |

## 联系支持

如以上步骤仍无法解决：
1. 联系QQ互联客服：open@tencent.com
2. 提供应用ID：1112459080
3. 描述具体错误场景和配置截图

## 临时解决方案

如果急需测试功能：
1. 使用手机号登录作为备选方案
2. 申请微信登录作为替代
3. 等待QQ互联审核完成后再启用QQ登录

## 配置验证清单

- [ ] QQ互联应用状态为"已上线"
- [ ] 回调地址配置正确且已保存
- [ ] 网站登录权限已启用
- [ ] 域名已备案（生产环境）
- [ ] 前后端配置参数一致
- [ ] 能够通过直接URL测试授权页面