import fs from 'fs'
import path from 'path'
import { defineEventHandler, readBody, createError } from 'h3'

export default defineEventHandler(async (event) => {
  const body = await readBody(event)
  const { src, category } = body

  if (!src) {
    throw createError({ statusCode: 400, statusMessage: 'Image source (src) is required' })
  }

  const metaPath = path.resolve(process.cwd(), 'public/gallery_meta.json')
  if (!fs.existsSync(metaPath)) {
    throw createError({ statusCode: 404, statusMessage: 'Metadata file not found' })
  }

  try {
    const rawData = fs.readFileSync(metaPath, 'utf8')
    let gallery = JSON.parse(rawData)

    // Find the item
    const itemIndex = gallery.findIndex((item: any) => item.src === src)
    if (itemIndex === -1) {
      throw createError({ statusCode: 404, statusMessage: 'Image not found in metadata' })
    }

    if (category === 'delete') {
      // Delete the file from the gallery folder
      const filename = path.basename(src)
      const filepath = path.resolve(process.cwd(), 'public/gallery', filename)
      if (fs.existsSync(filepath)) {
        fs.unlinkSync(filepath)
      }
      
      // Remove from metadata
      gallery.splice(itemIndex, 1)
      fs.writeFileSync(metaPath, JSON.stringify(gallery, null, 2), 'utf8')
      
      return { success: true, action: 'deleted', src }
    }

    // Validate category
    const validCategories = ['temple', 'idol', 'detail', 'social']
    if (!validCategories.includes(category)) {
      throw createError({ statusCode: 400, statusMessage: 'Invalid category' })
    }

    // Update category
    gallery[itemIndex].cat = category
    fs.writeFileSync(metaPath, JSON.stringify(gallery, null, 2), 'utf8')

    return { success: true, action: 'updated', src, category }
  } catch (err: any) {
    console.error('Error in recategorize endpoint:', err)
    throw createError({ statusCode: 500, statusMessage: err.message })
  }
})
