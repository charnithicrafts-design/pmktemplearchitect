import fs from 'fs'
import path from 'path'
import { defineEventHandler } from 'h3'

export default defineEventHandler(() => {
  const rawDir = path.resolve(process.cwd(), 'public/unzipped_raw')
  
  if (!fs.existsSync(rawDir)) {
    return []
  }

  try {
    const files = fs.readdirSync(rawDir)
    // Filter for common image formats and ignore hidden files
    const images = files.filter(file => {
      const ext = path.extname(file).toLowerCase()
      return (ext === '.jpeg' || ext === '.jpg' || ext === '.png' || ext === '.webp') && !file.startsWith('.')
    })
    
    // Sort them so they display in a deterministic order
    return images.sort()
  } catch (error) {
    console.error('Error reading uncurated directory:', error)
    return []
  }
})
