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
const allImages = [
  { src: '/gallery/img_001.jpeg', cat: 'temple' },
  { src: '/gallery/img_002.jpeg', cat: 'temple' },
  { src: '/gallery/img_003.jpeg', cat: 'temple' },
  { src: '/gallery/img_004.jpeg', cat: 'temple' },
  { src: '/gallery/img_005.jpeg', cat: 'temple' },
  { src: '/gallery/img_006.jpeg', cat: 'idol' },
  { src: '/gallery/img_007.jpeg', cat: 'idol' },
  { src: '/gallery/img_008.jpeg', cat: 'detail' },
  { src: '/gallery/img_009.jpeg', cat: 'detail' },
  { src: '/gallery/img_010.jpeg', cat: 'detail' },
  { src: '/gallery/img_011.jpeg', cat: 'detail' },
  { src: '/gallery/img_012.jpeg', cat: 'temple' },
  { src: '/gallery/img_013.jpeg', cat: 'temple' },
  { src: '/gallery/img_014.jpeg', cat: 'temple' },
  { src: '/gallery/img_015.jpeg', cat: 'temple' },
  { src: '/gallery/img_016.jpeg', cat: 'temple' },
  { src: '/gallery/img_017.jpeg', cat: 'idol' },
  { src: '/gallery/img_018.jpeg', cat: 'idol' },
  { src: '/gallery/img_019.jpeg', cat: 'idol' },
  { src: '/gallery/img_020.jpeg', cat: 'idol' },
  { src: '/gallery/img_021.jpeg', cat: 'detail' },
  { src: '/gallery/img_022.jpeg', cat: 'detail' },
  { src: '/gallery/img_023.jpeg', cat: 'detail' },
  { src: '/gallery/img_024.jpeg', cat: 'detail' },
  { src: '/gallery/img_025.jpeg', cat: 'detail' },
  { src: '/gallery/img_026.jpeg', cat: 'detail' },
  { src: '/gallery/img_027.jpeg', cat: 'idol' },
  { src: '/gallery/img_028.jpeg', cat: 'idol' },
  { src: '/gallery/img_029.jpeg', cat: 'idol' },
  { src: '/gallery/img_030.jpeg', cat: 'detail' },
  { src: '/gallery/img_031.jpeg', cat: 'detail' },
  { src: '/gallery/img_032.jpeg', cat: 'detail' },
  { src: '/gallery/img_033.jpeg', cat: 'detail' },
  { src: '/gallery/img_034.jpeg', cat: 'detail' },
  { src: '/gallery/img_035.jpeg', cat: 'idol' },
  { src: '/gallery/img_036.jpeg', cat: 'idol' },
  { src: '/gallery/img_037.jpeg', cat: 'idol' },
  { src: '/gallery/img_038.jpeg', cat: 'idol' },
  { src: '/gallery/img_039.jpeg', cat: 'idol' },
  { src: '/gallery/img_040.jpeg', cat: 'temple' },
  { src: '/gallery/img_041.jpeg', cat: 'temple' },
  { src: '/gallery/img_042.jpeg', cat: 'temple' },
  { src: '/gallery/img_043.jpeg', cat: 'temple' },
  { src: '/gallery/img_044.jpeg', cat: 'temple' },
  { src: '/gallery/img_045.jpeg', cat: 'temple' },
  { src: '/gallery/img_046.jpeg', cat: 'temple' },
  { src: '/gallery/img_047.jpeg', cat: 'detail' },
  { src: '/gallery/img_048.jpeg', cat: 'detail' },
  { src: '/gallery/img_049.jpeg', cat: 'temple' },
  { src: '/gallery/img_050.jpeg', cat: 'temple' },
  { src: '/gallery/img_051.jpeg', cat: 'temple' },
  { src: '/gallery/img_052.jpeg', cat: 'temple' },
  { src: '/gallery/img_053.jpeg', cat: 'temple' },
  { src: '/gallery/img_054.jpeg', cat: 'temple' },
  { src: '/gallery/img_055.jpeg', cat: 'temple' },
  { src: '/gallery/img_056.jpeg', cat: 'temple' },
  { src: '/gallery/img_057.jpeg', cat: 'temple' },
  { src: '/gallery/img_058.jpeg', cat: 'temple' },
  { src: '/gallery/img_059.jpeg', cat: 'temple' },
  { src: '/gallery/img_060.jpeg', cat: 'temple' },
  { src: '/gallery/img_061.jpeg', cat: 'temple' },
  { src: '/gallery/img_062.jpeg', cat: 'temple' },
  { src: '/gallery/img_063.jpeg', cat: 'temple' },
  { src: '/gallery/img_064.jpeg', cat: 'temple' },
  { src: '/gallery/img_065.jpeg', cat: 'temple' },
  { src: '/gallery/img_066.jpeg', cat: 'temple' },
  { src: '/gallery/img_067.jpeg', cat: 'detail' },
  { src: '/gallery/img_068.jpeg', cat: 'detail' },
  { src: '/gallery/img_069.jpeg', cat: 'temple' },
  { src: '/gallery/img_070.jpeg', cat: 'temple' },
  { src: '/gallery/img_071.jpeg', cat: 'temple' },
  { src: '/gallery/img_072.jpeg', cat: 'temple' },
  { src: '/gallery/img_073.jpeg', cat: 'temple' },
  { src: '/gallery/img_074.jpeg', cat: 'temple' },
  { src: '/gallery/img_075.jpeg', cat: 'temple' },
  { src: '/gallery/img_076.jpeg', cat: 'temple' },
  { src: '/gallery/img_077.jpeg', cat: 'temple' },
  { src: '/gallery/img_078.jpeg', cat: 'temple' },
  { src: '/gallery/img_079.jpeg', cat: 'temple' },
  { src: '/gallery/img_080.jpeg', cat: 'temple' },
  { src: '/gallery/img_081.jpeg', cat: 'temple' },
  { src: '/gallery/img_082.jpeg', cat: 'idol' },
  { src: '/gallery/img_083.jpeg', cat: 'idol' },
  { src: '/gallery/img_084.jpeg', cat: 'idol' },
  { src: '/gallery/img_085.jpeg', cat: 'idol' },
  { src: '/gallery/img_086.jpeg', cat: 'idol' },
  { src: '/gallery/img_087.jpeg', cat: 'idol' },
  { src: '/gallery/img_088.jpeg', cat: 'idol' },
  { src: '/gallery/img_089.jpeg', cat: 'idol' },
  { src: '/gallery/img_090.jpeg', cat: 'temple' },
  { src: '/gallery/img_091.jpeg', cat: 'temple' },
  { src: '/gallery/img_092.jpeg', cat: 'temple' },
  { src: '/gallery/img_093.jpeg', cat: 'temple' },
  { src: '/gallery/img_094.jpeg', cat: 'temple' },
  { src: '/gallery/img_095.jpeg', cat: 'temple' },
  { src: '/gallery/img_096.jpeg', cat: 'temple' },
  { src: '/gallery/img_097.jpeg', cat: 'temple' },
  { src: '/gallery/img_098.jpeg', cat: 'temple' },
  { src: '/gallery/img_099.jpeg', cat: 'temple' },
  { src: '/gallery/img_100.jpeg', cat: 'temple' },
  { src: '/gallery/img_101.jpeg', cat: 'temple' },
  { src: '/gallery/img_102.jpeg', cat: 'temple' },
  { src: '/gallery/img_103.jpeg', cat: 'temple' },
  { src: '/gallery/img_104.jpeg', cat: 'temple' },
  { src: '/gallery/img_105.jpeg', cat: 'temple' },
  { src: '/gallery/img_106.jpeg', cat: 'temple' },
  { src: '/gallery/img_107.jpeg', cat: 'temple' },
  { src: '/gallery/img_108.jpeg', cat: 'detail' },
  { src: '/gallery/img_109.jpeg', cat: 'detail' },
  { src: '/gallery/img_110.jpeg', cat: 'detail' },
  { src: '/gallery/img_111.jpeg', cat: 'detail' },
  { src: '/gallery/img_112.jpeg', cat: 'detail' },
  { src: '/gallery/img_113.jpeg', cat: 'detail' },
  { src: '/gallery/img_114.jpeg', cat: 'idol' },
  { src: '/gallery/img_115.jpeg', cat: 'idol' },
  { src: '/gallery/img_116.jpeg', cat: 'idol' },
  { src: '/gallery/img_117.jpeg', cat: 'idol' },
  { src: '/gallery/img_118.jpeg', cat: 'idol' },
  { src: '/gallery/img_119.jpeg', cat: 'temple' },
  { src: '/gallery/img_120.jpeg', cat: 'temple' },
  { src: '/gallery/img_121.jpeg', cat: 'temple' },
  { src: '/gallery/img_122.jpeg', cat: 'temple' },
  { src: '/gallery/img_123.jpeg', cat: 'temple' },
  { src: '/gallery/img_124.jpeg', cat: 'temple' },
  { src: '/gallery/img_125.jpeg', cat: 'detail' },
  { src: '/gallery/img_126.jpeg', cat: 'detail' },
  { src: '/gallery/img_127.jpeg', cat: 'detail' },
  { src: '/gallery/img_128.jpeg', cat: 'temple' },
  { src: '/gallery/img_129.jpeg', cat: 'temple' },
].map((img, i) => ({ ...img, alt: `PMK Temple Work ${i + 1}` }))

const filteredImages = computed(() =>
  activeFilter.value === 'all' ? allImages : allImages.filter(img => img.cat === activeFilter.value)
)

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
