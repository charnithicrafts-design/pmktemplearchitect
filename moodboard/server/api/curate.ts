import fs from 'fs'
import path from 'path'
import { defineEventHandler, readBody, createError } from 'h3'

export default defineEventHandler(async (event) => {
  const body = await readBody(event)
  const { filename, category } = body

  if (!filename) {
    throw createError({ statusCode: 400, statusMessage: 'Filename is required' })
  }

  const rawFilePath = path.resolve(process.cwd(), 'public/unzipped_raw', filename)
  if (!fs.existsSync(rawFilePath)) {
    throw createError({ statusCode: 404, statusMessage: 'Source file not found' })
  }

  // Handle SKIP/DELETE operation
  if (category === 'skip') {
    try {
      fs.unlinkSync(rawFilePath)
      return { success: true, action: 'skipped', filename }
    } catch (err) {
      console.error('Error deleting skipped file:', err)
      throw createError({ statusCode: 500, statusMessage: 'Failed to delete file' })
    }
  }

  // Validate category
  const validCategories = ['temple', 'idol', 'detail', 'social']
  if (!validCategories.includes(category)) {
    throw createError({ statusCode: 400, statusMessage: 'Invalid category: must be temple, idol, detail, or social' })
  }

  try {
    const metaPath = path.resolve(process.cwd(), 'public/gallery_meta.json')
    let gallery = []

    if (fs.existsSync(metaPath)) {
      const rawData = fs.readFileSync(metaPath, 'utf8')
      gallery = JSON.parse(rawData)
    }

    // Determine the next index
    // e.g. /gallery/img_129.jpeg -> index 129
    let nextIndex = 1
    if (gallery.length > 0) {
      // Find the maximum numerical index from the existing gallery sources
      const indices = gallery.map((item: any) => {
        const match = item.src.match(/img_(\d+)\./)
        return match ? parseInt(match[1], 10) : 0
      })
      nextIndex = Math.max(...indices) + 1
    }

    // Determine the file extension
    const ext = path.extname(filename).toLowerCase() || '.jpeg'
    const newFilename = `img_${String(nextIndex).padStart(3, '0')}${ext}`
    const destFilePath = path.resolve(process.cwd(), 'public/gallery', newFilename)

    // Ensure target gallery directory exists
    const galleryDir = path.resolve(process.cwd(), 'public/gallery')
    if (!fs.existsSync(galleryDir)) {
      fs.mkdirSync(galleryDir, { recursive: true })
    }

    // Copy file to gallery and then delete the source
    fs.copyFileSync(rawFilePath, destFilePath)
    fs.unlinkSync(rawFilePath)

    // Append to metadata
    const newItem = {
      src: `/gallery/${newFilename}`,
      cat: category,
      alt: `PMK Temple Work ${nextIndex}`
    }
    gallery.push(newItem)

    // Save metadata file
    fs.writeFileSync(metaPath, JSON.stringify(gallery, null, 2), 'utf8')

    return {
      success: true,
      action: 'curated',
      source: filename,
      destination: newFilename,
      item: newItem
    }
  } catch (err: any) {
    console.error('Error during curation processing:', err)
    throw createError({ statusCode: 500, statusMessage: `Curation error: ${err.message}` })
  }
})
