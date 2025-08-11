import express from 'express'
const router = express.Router()

// 模拟情绪分析数据
const emotionAnalysis = {
  colors: {
    '#ef4444': { angry: 0.8, excited: 0.2 },
    '#f59e0b': { excited: 0.7, happy: 0.3 },
    '#10b981': { happy: 0.9, calm: 0.1 },
    '#06b6d4': { calm: 0.8, sad: 0.2 },
    '#6366f1': { sad: 0.7, calm: 0.3 },
    '#8b5cf6': { anxious: 0.8, sad: 0.2 },
    '#ec4899': { excited: 0.6, happy: 0.4 }
  },
  
  strokes: {
    fast: { excited: 0.7, angry: 0.3 },
    slow: { calm: 0.6, sad: 0.4 },
    medium: { happy: 0.5, calm: 0.5 }
  }
}

/**
 * @typedef {object} EmotionStats
 * @property {object} emotions - 情绪统计
 * @property {number} totalArtworks - 总作品数
 * @property {object} trends - 情绪趋势
 */

/**
 * @typedef {object} EmotionAnalysis
 * @property {string} primaryEmotion - 主要情绪
 * @property {object} emotionScores - 情绪评分
 * @property {object} insights - 洞察分析
 */

/**
 * GET /api/emotions/stats
 * @summary 获取情绪统计数据
 * @tags emotions
 * @return {EmotionStats} 200 - 情绪统计
 */
router.get('/stats', (req, res) => {
  // 模拟统计数据
  const stats = {
    emotions: {
      happy: Math.floor(Math.random() * 20) + 5,
      sad: Math.floor(Math.random() * 15) + 3,
      angry: Math.floor(Math.random() * 10) + 2,
      calm: Math.floor(Math.random() * 25) + 8,
      excited: Math.floor(Math.random() * 18) + 4,
      anxious: Math.floor(Math.random() * 12) + 3
    },
    totalArtworks: 100,
    trends: {
      thisWeek: {
        happy: 3,
        calm: 5,
        excited: 2
      },
      lastWeek: {
        sad: 2,
        anxious: 1,
        calm: 4
      }
    }
  }
  
  res.json(stats)
})

/**
 * POST /api/emotions/analyze
 * @summary 分析绘画情绪
 * @tags emotions
 * @param {object} request.body.required - 绘画数据
 * @return {EmotionAnalysis} 200 - 情绪分析结果
 */
router.post('/analyze', (req, res) => {
  const { paths, colors } = req.body
  
  // 简单的情绪分析算法
  let emotionScores = {
    happy: 0,
    sad: 0,
    angry: 0,
    calm: 0,
    excited: 0,
    anxious: 0
  }
  
  // 基于颜色分析
  if (colors && colors.length > 0) {
    colors.forEach(color => {
      if (emotionAnalysis.colors[color]) {
        Object.entries(emotionAnalysis.colors[color]).forEach(([emotion, score]) => {
          emotionScores[emotion] += score
        })
      }
    })
  }
  
  // 基于笔触分析（简化版）
  if (paths && paths.length > 0) {
    const avgSpeed = paths.reduce((sum, path) => {
      if (path.points.length < 2) return sum
      const duration = path.points[path.points.length - 1].timestamp - path.points[0].timestamp
      const distance = path.points.reduce((dist, point, index) => {
        if (index === 0) return dist
        const prev = path.points[index - 1]
        return dist + Math.sqrt(Math.pow(point.x - prev.x, 2) + Math.pow(point.y - prev.y, 2))
      }, 0)
      return sum + (distance / Math.max(duration, 1))
    }, 0) / paths.length
    
    if (avgSpeed > 0.5) {
      emotionScores.excited += 0.3
      emotionScores.angry += 0.2
    } else if (avgSpeed < 0.2) {
      emotionScores.calm += 0.4
      emotionScores.sad += 0.1
    } else {
      emotionScores.happy += 0.3
      emotionScores.calm += 0.2
    }
  }
  
  // 找出主要情绪
  const primaryEmotion = Object.entries(emotionScores)
    .sort(([,a], [,b]) => b - a)[0][0]
  
  // 生成洞察
  const insights = {
    dominantColor: colors && colors.length > 0 ? colors[0] : '#6366f1',
    strokePattern: paths && paths.length > 5 ? 'complex' : 'simple',
    emotionalIntensity: Math.max(...Object.values(emotionScores))
  }
  
  res.json({
    primaryEmotion,
    emotionScores,
    insights
  })
})

/**
 * GET /api/emotions/suggestions
 * @summary 获取情绪建议
 * @tags emotions
 * @param {string} emotion.query.required - 情绪类型
 * @return {object} 200 - 情绪建议
 */
router.get('/suggestions', (req, res) => {
  const { emotion } = req.query
  
  const suggestions = {
    happy: {
      colors: ['#10b981', '#f59e0b', '#84cc16'],
      activities: ['尝试明亮的色彩组合', '画一些让你开心的事物'],
      message: '保持这份快乐，用色彩传递正能量！'
    },
    sad: {
      colors: ['#6366f1', '#06b6d4', '#8b5cf6'],
      activities: ['用蓝色调表达情感', '让笔触随着心情流动'],
      message: '悲伤是暂时的，艺术是永恒的慰藉。'
    },
    angry: {
      colors: ['#ef4444', '#f97316', '#dc2626'],
      activities: ['用强烈的笔触释放情绪', '尝试红色和橙色的碰撞'],
      message: '让画笔成为你的情绪出口。'
    },
    calm: {
      colors: ['#06b6d4', '#10b981', '#8b5cf6'],
      activities: ['使用柔和的渐变色', '保持缓慢而稳定的笔触'],
      message: '在宁静中找到内心的平衡。'
    },
    excited: {
      colors: ['#f59e0b', '#ec4899', '#84cc16'],
      activities: ['尝试动态的线条', '用鲜艳的色彩表达活力'],
      message: '让兴奋的能量在画布上绽放！'
    },
    anxious: {
      colors: ['#8b5cf6', '#06b6d4', '#6366f1'],
      activities: ['用重复的图案缓解焦虑', '专注于每一笔的呼吸'],
      message: '绘画是缓解焦虑的良药。'
    }
  }
  
  res.json(suggestions[emotion] || suggestions.calm)
})

export default router