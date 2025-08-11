import express from 'express'
import { authenticateToken } from '../middleware/auth.js'

const router = express.Router()

// 内存存储（实际应用中应使用数据库）
let artworks = []

/**
 * @typedef {object} Artwork
 * @property {string} id - 作品ID
 * @property {string} title - 作品标题
 * @property {Array} paths - 绘画路径
 * @property {string} emotion - 情绪类型
 * @property {string} backgroundColor - 背景颜色
 * @property {number} createdAt - 创建时间戳
 * @property {string} thumbnail - 缩略图URL
 */

/**
 * GET /api/artworks
 * @summary 获取所有作品
 * @tags artworks
 * @return {array<Artwork>} 200 - 作品列表
 */
router.get('/', authenticateToken, (req, res) => {
  res.json(artworks)
})

/**
 * GET /api/artworks/{id}
 * @summary 获取单个作品
 * @tags artworks
 * @param {string} id.path.required - 作品ID
 * @return {Artwork} 200 - 作品详情
 * @return {object} 404 - 作品未找到
 */
router.get('/:id', authenticateToken, (req, res) => {
  const artwork = artworks.find(a => a.id === req.params.id)
  if (!artwork) {
    return res.status(404).json({ error: '作品未找到' })
  }
  res.json(artwork)
})

/**
 * POST /api/artworks
 * @summary 创建新作品
 * @tags artworks
 * @param {Artwork} request.body.required - 作品数据
 * @return {Artwork} 201 - 创建成功的作品
 */
router.post('/', authenticateToken, (req, res) => {
  const artwork = {
    id: Date.now().toString(),
    title: req.body.title || `作品 ${new Date().toLocaleString('zh-CN')}`,
    paths: req.body.paths || [],
    emotion: req.body.emotion || 'calm',
    backgroundColor: req.body.backgroundColor || '#0f172a',
    createdAt: Date.now(),
    thumbnail: req.body.thumbnail || '',
    ...req.body
  }
  
  artworks.unshift(artwork)
  res.status(201).json(artwork)
})

/**
 * PUT /api/artworks/{id}
 * @summary 更新作品
 * @tags artworks
 * @param {string} id.path.required - 作品ID
 * @param {Artwork} request.body.required - 更新数据
 * @return {Artwork} 200 - 更新后的作品
 * @return {object} 404 - 作品未找到
 */
router.put('/:id', authenticateToken, (req, res) => {
  const index = artworks.findIndex(a => a.id === req.params.id)
  if (index === -1) {
    return res.status(404).json({ error: '作品未找到' })
  }
  
  artworks[index] = { ...artworks[index], ...req.body }
  res.json(artworks[index])
})

/**
 * DELETE /api/artworks/{id}
 * @summary 删除作品
 * @tags artworks
 * @param {string} id.path.required - 作品ID
 * @return {object} 200 - 删除成功
 * @return {object} 404 - 作品未找到
 */
router.delete('/:id', authenticateToken, (req, res) => {
  const index = artworks.findIndex(a => a.id === req.params.id)
  if (index === -1) {
    return res.status(404).json({ error: '作品未找到' })
  }
  
  artworks.splice(index, 1)
  res.json({ message: '作品删除成功' })
})

/**
 * POST /api/artworks/{id}/thumbnail
 * @summary 上传作品缩略图
 * @tags artworks
 * @param {string} id.path.required - 作品ID
 * @param {file} file.formData.required - 缩略图文件
 * @return {object} 200 - 上传成功
 */
router.post('/:id/thumbnail', authenticateToken, (req, res) => {
  // 这里应该处理文件上传，简化处理
  const artwork = artworks.find(a => a.id === req.params.id)
  if (!artwork) {
    return res.status(404).json({ error: '作品未找到' })
  }
  
  // 模拟文件上传
  const filename = `thumbnails/${req.params.id}.png`
  artwork.thumbnail = `/uploads/${filename}`
  
  res.json({ thumbnail: artwork.thumbnail })
})

export default router