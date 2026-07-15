<template>
  <div>
    <!-- PAGE HERO -->
    <section class="page-hero">
      <div class="page-hero-bg">
        <img src="/gallery/img_016.jpeg" alt="Gallery" />
        <div class="page-hero-overlay" />
      </div>
      <div class="container page-hero-content">
        <span class="section-label">Our Portfolio</span>
        <h1 class="section-title">Gallery</h1>
        <p class="section-sub">A glimpse into decades of sacred craftsmanship — temples built, idols carved, and traditions honoured.</p>
      </div>
    </section>

    <!-- FILTER TABS -->
    <section class="gallery-section">
      <div class="container">
        <div class="filter-bar">
          <button
            v-for="cat in categories"
            :key="cat.key"
            class="filter-btn"
            :class="{ active: activeFilter === cat.key }"
            @click="activeFilter = cat.key"
          >
            {{ cat.label }}
          </button>
        </div>

        <!-- MASONRY GRID -->
        <div class="gallery-grid">
          <div
            v-for="(img, i) in filteredImages"
            :key="i"
            class="gallery-item"
            :class="{ tall: i % 5 === 0 }"
            @click="openLightbox(i)"
          >
            <img :src="img.src" :alt="img.alt" loading="lazy" />
            <div class="item-overlay">
              <span class="zoom-icon">🔍</span>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- LIGHTBOX -->
    <Teleport to="body">
      <div v-if="lightboxOpen" class="lightbox" @click.self="closeLightbox">
        <button class="lb-close" @click="closeLightbox">✕</button>
        <button class="lb-prev" @click="prevImg">‹</button>
        <img :src="filteredImages[lightboxIndex]?.src" :alt="filteredImages[lightboxIndex]?.alt" class="lb-img" />
        <button class="lb-next" @click="nextImg">›</button>
        <p class="lb-counter">{{ lightboxIndex + 1 }} / {{ filteredImages.length }}</p>
      </div>
    </Teleport>
  </div>
</template>

<script setup>
useHead({ title: 'Gallery | P.M.K. Temple Architect' })

const activeFilter = ref('all')
const lightboxOpen = ref(false)
const lightboxIndex = ref(0)

const categories = [
  { key: 'all', label: 'All Work' },
  { key: 'temple', label: 'Temples' },
  { key: 'idol', label: 'Idols & Sculptures' },
  { key: 'detail', label: 'Fine Details' },
]

// img_001 → img_004: early temple work
// img_005 → img_016: temple exteriors
// img_017 → img_050: idol & detail work
// img_051 → img_129: large temple gallery
// Fetch gallery metadata from the public JSON file (which gets updated by the curator dashboard)
const { data: allImages } = await useAsyncData('gallery-meta', () => $fetch('/gallery_meta.json'))

const filteredImages = computed(() => {
  const images = allImages.value || []
  return activeFilter.value === 'all' ? images : images.filter(img => img.cat === activeFilter.value)
})

function openLightbox (i) { lightboxIndex.value = i; lightboxOpen.value = true }
function closeLightbox () { lightboxOpen.value = false }
function prevImg () { lightboxIndex.value = (lightboxIndex.value - 1 + filteredImages.value.length) % filteredImages.value.length }
function nextImg () { lightboxIndex.value = (lightboxIndex.value + 1) % filteredImages.value.length }

onMounted(() => {
  window.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') closeLightbox()
    if (e.key === 'ArrowLeft') prevImg()
    if (e.key === 'ArrowRight') nextImg()
  })
})
</script>

<style scoped>
.page-hero {
  position: relative; height: 40vh; min-height: 280px;
  display: flex; align-items: flex-end; overflow: hidden;
}
.page-hero-bg { position: absolute; inset: 0; }
.page-hero-bg img { width: 100%; height: 100%; object-fit: cover; }
.page-hero-overlay { position: absolute; inset: 0; background: linear-gradient(to top, rgba(13,15,20,1) 0%, rgba(13,15,20,0.5) 100%); }
.page-hero-content { position: relative; z-index: 1; padding-bottom: 3rem; }
.page-hero-content .section-title { color: #fff; }

.gallery-section { padding: 3rem 0 6rem; }
.filter-bar {
  display: flex; gap: 0.75rem; flex-wrap: wrap; margin-bottom: 2.5rem;
}
.filter-btn {
  padding: 0.5rem 1.25rem; border-radius: 50px;
  border: 1px solid var(--border); background: var(--bg-card);
  color: var(--text-muted); font-family: var(--font-sans);
  font-size: 0.875rem; font-weight: 500; cursor: pointer; transition: var(--transition);
}
.filter-btn:hover, .filter-btn.active {
  background: var(--gold-muted); border-color: var(--gold); color: var(--gold);
}

.gallery-grid { columns: 4; column-gap: 0.75rem; }
.gallery-item {
  break-inside: avoid; margin-bottom: 0.75rem;
  border-radius: var(--radius); overflow: hidden;
  position: relative; cursor: pointer;
}
.gallery-item img { width: 100%; display: block; transition: transform 0.5s ease; }
.gallery-item.tall img { aspect-ratio: 2/3; object-fit: cover; }
.item-overlay {
  position: absolute; inset: 0;
  background: rgba(13,15,20,0.6);
  display: flex; align-items: center; justify-content: center;
  opacity: 0; transition: var(--transition);
}
.zoom-icon { font-size: 2rem; }
.gallery-item:hover .item-overlay { opacity: 1; }
.gallery-item:hover img { transform: scale(1.05); }

.lightbox {
  position: fixed; inset: 0; z-index: 9999;
  background: rgba(0,0,0,0.95);
  display: flex; align-items: center; justify-content: center;
}
.lb-img { max-height: 90vh; max-width: 90vw; object-fit: contain; border-radius: 8px; }
.lb-close, .lb-prev, .lb-next {
  position: absolute; background: rgba(255,255,255,0.1); border: none;
  color: #fff; cursor: pointer; border-radius: 50%;
  width: 48px; height: 48px; display: flex; align-items: center; justify-content: center;
  transition: var(--transition);
}
.lb-close:hover, .lb-prev:hover, .lb-next:hover { background: var(--gold-muted); color: var(--gold); }
.lb-close { top: 1.5rem; right: 1.5rem; font-size: 1.2rem; }
.lb-prev { left: 1.5rem; top: 50%; transform: translateY(-50%); font-size: 2rem; }
.lb-next { right: 1.5rem; top: 50%; transform: translateY(-50%); font-size: 2rem; }
.lb-counter { position: absolute; bottom: 1.5rem; left: 50%; transform: translateX(-50%); color: var(--text-muted); font-size: 0.875rem; }

@media (max-width: 1024px) { .gallery-grid { columns: 3; } }
@media (max-width: 768px) { .gallery-grid { columns: 2; } }
@media (max-width: 480px) { .gallery-grid { columns: 1; } }
</style>
