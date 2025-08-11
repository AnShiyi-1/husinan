import express from 'express'
import cors from 'cors'
import path from 'path'
import { fileURLToPath } from 'url'
import expressJSDocSwagger from 'express-jsdoc-swagger'
import artworkRoutes from './routes/artworks.js'
import authRoutes from './routes/auth.js'
import emotionRoutes from './routes/emotions.js'
import oauthRoutes from './routes/oauth.js'

const __filename = fileURLToPath(import.meta.url)
const __dirname = path.dirname(__filename)

const app = express()
const PORT = process.env.PORT || 3001;

// 中间件
app.use(cors())
app.use(express.json())
app.use(express.static(path.join(__dirname, '../dist')))

// Swagger 文档配置
const options = {
  info: {
    version: '1.0.0',
    title: '情绪画布 API',
    description: '一个让你通过绘画表达情绪的创意平台 API',
  },
  baseDir: __dirname,
  filesPattern: ['./routes/*.js', './models/*.js'],
  swaggerUIPath: '/api-docs',
  exposeSwaggerUI: true,
  exposeApiDocs: true,
  apiDocsPath: '/api-docs.json',
  notRequiredAsNullable: false,
  swaggerUiOptions: {
    customCss: '.swagger-ui .topbar { display: none }'
  }
}

expressJSDocSwagger(app)(options)

// 路由
app.use('/api/artworks', artworkRoutes)
app.use('/api/auth', authRoutes)
app.use('/api/emotions', emotionRoutes)
app.use('/api/oauth', oauthRoutes)

// 健康检查
app.get('/api/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() })
})

// 服务前端
app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, '../dist/index.html'))
})

// 错误处理
app.use((err, req, res, next) => {
  console.error(err.stack)
  res.status(500).json({ error: '服务器内部错误' })
})

app.listen(PORT, () => {
  console.log(`服务器运行在端口 ${PORT}`)
  console.log(`API文档: http://localhost:${PORT}/api-docs`)
})

export default app