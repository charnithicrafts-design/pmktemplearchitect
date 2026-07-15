const fs = require('fs');
const path = require('path');

const galleryVuePath = path.join(__dirname, '..', 'pages', 'gallery.vue');
const galleryMetaPath = path.join(__dirname, '..', 'public', 'gallery_meta.json');

try {
  const content = fs.readFileSync(galleryVuePath, 'utf8');
  // Match the array content inside the const allImages block
  const match = content.match(/const allImages = \[\s*([\s\S]*?)\s*\]\.map/);
  if (!match) {
    throw new Error("Could not find allImages array in gallery.vue");
  }

  const arrayStr = match[1];
  // Parse entries like { src: '/gallery/img_001.jpeg', cat: 'temple' }
  const regex = /\{\s*src:\s*'([^']+)',\s*cat:\s*'([^']+)'\s*\}/g;
  const images = [];
  let m;
  let index = 1;
  while ((m = regex.exec(arrayStr)) !== null) {
    images.push({
      src: m[1],
      cat: m[2],
      alt: `PMK Temple Work ${index}`
    });
    index++;
  }

  fs.writeFileSync(galleryMetaPath, JSON.stringify(images, null, 2), 'utf8');
  console.log(`Successfully generated gallery_meta.json with ${images.length} entries at ${galleryMetaPath}`);
} catch (err) {
  console.error("Error generating gallery_meta.json:", err);
  process.exit(1);
}
