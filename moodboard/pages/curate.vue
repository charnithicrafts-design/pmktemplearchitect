<template>
  <div class="curator-container">
    <div class="curator-header">
      <div class="container header-inner">
        <div class="brand">
          <span class="logo-mark">PMK</span>
          <h1>Image Curation Dashboard</h1>
        </div>
        
        <!-- Toggle Mode -->
        <div class="mode-tabs">
          <button 
            class="tab-btn" 
            :class="{ active: mode === 'new' }"
            @click="setMode('new')"
          >
            📂 Curate New ({{ newImages.length }})
          </button>
          <button 
            class="tab-btn" 
            :class="{ active: mode === 'review' }"
            @click="setMode('review')"
          >
            👁️ Review Gallery ({{ reviewImages.length }})
          </button>
        </div>

        <NuxtLink to="/gallery" class="btn btn-outline btn-sm">Go to Gallery →</NuxtLink>
      </div>
    </div>

    <div class="container main-content">
      <!-- Mode options for Review -->
      <div v-if="mode === 'review'" class="review-filters">
        <span class="filter-label">Filter by Category:</span>
        <button 
          v-for="cat in filterCategories" 
          :key="cat.key" 
          class="filter-tab"
          :class="{ active: reviewFilter === cat.key }"
          @click="setReviewFilter(cat.key)"
        >
          {{ cat.label }} ({{ getCategoryCount(cat.key) }})
        </button>
      </div>

      <!-- Loading state -->
      <div v-if="loading" class="state-card loading-card">
        <div class="spinner" />
        <p>Loading files...</p>
      </div>

      <!-- Empty state for new uploads -->
      <div v-else-if="mode === 'new' && newImages.length === 0" class="state-card empty-card">
        <span class="empty-icon">🎉</span>
        <h2>All Done!</h2>
        <p>There are no more images to curate in <code>public/unzipped_raw/</code>.</p>
        <button class="btn btn-outline" @click="setMode('review')">Review existing gallery images</button>
      </div>

      <!-- Empty state for review filters -->
      <div v-else-if="mode === 'review' && filteredReviewImages.length === 0" class="state-card empty-card">
        <span class="empty-icon">📂</span>
        <h2>Empty Category</h2>
        <p>No images found matching category filter <strong>"{{ reviewFilter }}"</strong>.</p>
        <button class="btn btn-outline" @click="setReviewFilter('all')">Show all categories</button>
      </div>

      <!-- Curator Workspace -->
      <div v-else class="workspace-grid">
        <!-- Visual Panel -->
        <div class="visual-panel">
          <div class="image-wrapper">
            <img 
              :src="currentImageSrc" 
              :alt="currentImageName" 
              class="uncurated-image"
              @load="imageLoaded = true"
            />
            <div v-if="!imageLoaded" class="image-placeholder">
              <div class="spinner" />
            </div>
          </div>
          <div class="image-meta">
            <span class="filename" :title="currentImageName">{{ currentImageName }}</span>
            <div class="meta-right">
              <span v-if="mode === 'review'" class="current-cat-badge">Current: {{ currentItemCategory }}</span>
              <span class="progress-indicator">Image {{ currentIndex + 1 }} of {{ totalImagesCount }}</span>
            </div>
          </div>
          
          <!-- Navigation in Review Mode -->
          <div v-if="mode === 'review'" class="review-nav">
            <button class="btn btn-outline btn-xs" @click="prevItem" :disabled="currentIndex === 0">◀ Prev</button>
            <span class="nav-count">{{ currentIndex + 1 }} / {{ totalImagesCount }}</span>
            <button class="btn btn-outline btn-xs" @click="nextItem" :disabled="currentIndex === totalImagesCount - 1">Next ▶</button>
          </div>
        </div>

        <!-- Control Panel -->
        <div class="control-panel">
          <h2>{{ mode === 'new' ? 'Select Category' : 'Change Category' }}</h2>
          <p class="instruction">
            {{ mode === 'new' 
              ? 'Choose a category to move this raw file into the public gallery.' 
              : 'Update the category for this live gallery image. The change will save instantly.' 
            }}
          </p>

          <div class="button-stack">
            <button 
              class="btn-curate btn-temple" 
              :class="{ highlighted: currentItemCategory === 'temple' }"
              :disabled="processing"
              @click="handleCategoryAction('temple')"
            >
              <span class="key-hint">1</span>
              <span class="label">🕌 Temple Architecture</span>
            </button>

            <button 
              class="btn-curate btn-idol" 
              :class="{ highlighted: currentItemCategory === 'idol' }"
              :disabled="processing"
              @click="handleCategoryAction('idol')"
            >
              <span class="key-hint">2</span>
              <span class="label">🗿 Idol / Sculpture</span>
            </button>

            <button 
              class="btn-curate btn-detail" 
              :class="{ highlighted: currentItemCategory === 'detail' }"
              :disabled="processing"
              @click="handleCategoryAction('detail')"
            >
              <span class="key-hint">3</span>
              <span class="label">🔍 Fine Stone Details</span>
            </button>

            <button 
              class="btn-curate btn-social" 
              :class="{ highlighted: currentItemCategory === 'social' }"
              :disabled="processing"
              @click="handleCategoryAction('social')"
            >
              <span class="key-hint">4</span>
              <span class="label">🎉 Events & Social</span>
            </button>

            <div class="separator">or</div>

            <button 
              class="btn-curate btn-skip" 
              :disabled="processing"
              @click="handleCategoryAction('skip')"
            >
              <span class="key-hint">5</span>
              <span class="label">🗑️ {{ mode === 'new' ? 'Skip / Delete Image' : 'Remove from Gallery' }}</span>
            </button>
          </div>

          <!-- Shortcuts Legend -->
          <div class="shortcuts-legend">
            <h3>⌨️ Keyboard Shortcuts</h3>
            <div class="shortcut-list">
              <div class="shortcut-item"><span>1</span> Temple</div>
              <div class="shortcut-item"><span>2</span> Idol</div>
              <div class="shortcut-item"><span>3</span> Detail</div>
              <div class="shortcut-item"><span>4</span> Social</div>
              <div class="shortcut-item"><span>5</span> / <span>Del</span> Delete</div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
useHead({ title: 'Curation | P.M.K. Temple Architect' })

const mode = ref('new') // 'new' or 'review'
const loading = ref(true)
const processing = ref(false)
const imageLoaded = ref(false)

// New uploads state
const newImages = ref([])
const newIndex = ref(0)

// Review gallery state
const reviewImages = ref([])
const reviewIndex = ref(0)
const reviewFilter = ref('all')

const filterCategories = [
  { key: 'all', label: 'All' },
  { key: 'temple', label: 'Temples' },
  { key: 'idol', label: 'Idols' },
  { key: 'detail', label: 'Details' },
  { key: 'social', label: 'Social' }
]

// Computed getters based on current mode
const filteredReviewImages = computed(() => {
  if (reviewFilter.value === 'all') return reviewImages.value
  return reviewImages.value.filter(img => img.cat === reviewFilter.value)
})

const currentIndex = computed({
  get() {
    return mode.value === 'new' ? newIndex.value : reviewIndex.value
  },
  set(val) {
    if (mode.value === 'new') {
      newIndex.value = val
    } else {
      reviewIndex.value = val
    }
  }
})

const totalImagesCount = computed(() => {
  return mode.value === 'new' ? newImages.value.length : filteredReviewImages.value.length
})

const currentImageName = computed(() => {
  if (mode.value === 'new') {
    return newImages.value[newIndex.value] || ''
  } else {
    const item = filteredReviewImages.value[reviewIndex.value]
    return item ? item.src.split('/').pop() : ''
  }
})

const currentImageSrc = computed(() => {
  if (mode.value === 'new') {
    return currentImageName.value ? `/unzipped_raw/${currentImageName.value}` : ''
  } else {
    const item = filteredReviewImages.value[reviewIndex.value]
    return item ? item.src : ''
  }
})

const currentItemCategory = computed(() => {
  if (mode.value === 'new') return ''
  const item = filteredReviewImages.value[reviewIndex.value]
  return item ? item.cat : ''
})

// Lifecycle load
async function loadAllData() {
  loading.value = true
  try {
    const [uncurated, galleryMeta] = await Promise.all([
      $fetch('/api/uncurated'),
      $fetch('/gallery_meta.json').catch(() => [])
    ])
    newImages.value = uncurated
    reviewImages.value = galleryMeta
    newIndex.value = 0
    reviewIndex.value = 0
    imageLoaded.value = false
  } catch (err) {
    console.error('Error loading data:', err)
  } finally {
    loading.value = false
  }
}

// Category counters for Review mode
function getCategoryCount(catKey) {
  if (catKey === 'all') return reviewImages.value.length
  return reviewImages.value.filter(img => img.cat === catKey).length
}

function setMode(newMode) {
  mode.value = newMode
  currentIndex.value = 0
  imageLoaded.value = false
}

function setReviewFilter(filterKey) {
  reviewFilter.value = filterKey
  reviewIndex.value = 0
  imageLoaded.value = false
}

function prevItem() {
  if (currentIndex.value > 0) {
    currentIndex.value--
    imageLoaded.value = false
  }
}

function nextItem() {
  if (currentIndex.value < totalImagesCount.value - 1) {
    currentIndex.value++
    imageLoaded.value = false
  }
}

// Route Curation Action
async function handleCategoryAction(category) {
  if (processing.value || !currentImageName.value) return
  
  processing.value = true
  imageLoaded.value = false

  if (mode.value === 'new') {
    // Process new image
    try {
      const res = await $fetch('/api/curate', {
        method: 'POST',
        body: { filename: currentImageName.value, category }
      })
      if (res.success) {
        // Remove from list
        newImages.value.splice(newIndex.value, 1)
        // Add to review list locally
        if (category !== 'skip') {
          reviewImages.value.push(res.item)
        }
        adjustIndexAfterRemoval()
      }
    } catch (err) {
      alert(`Error curating file: ${err.statusMessage || err.message}`)
    } finally {
      processing.value = false
    }
  } else {
    // Recategorize or Delete existing image
    const item = filteredReviewImages.value[reviewIndex.value]
    if (!item) return

    const targetCategory = category === 'skip' ? 'delete' : category

    try {
      const res = await $fetch('/api/recategorize', {
        method: 'POST',
        body: { src: item.src, category: targetCategory }
      })
      if (res.success) {
        const globalIndex = reviewImages.value.findIndex(img => img.src === item.src)
        if (globalIndex !== -1) {
          if (targetCategory === 'delete') {
            reviewImages.value.splice(globalIndex, 1)
            adjustIndexAfterRemoval()
          } else {
            reviewImages.value[globalIndex].cat = targetCategory
            // Go to next item automatically
            nextItem()
          }
        }
      }
    } catch (err) {
      alert(`Error updating file: ${err.statusMessage || err.message}`)
    } finally {
      processing.value = false
    }
  }
}

function adjustIndexAfterRemoval() {
  if (currentIndex.value >= totalImagesCount.value) {
    currentIndex.value = Math.max(0, totalImagesCount.value - 1)
  }
}

function handleKeyDown(e) {
  if (loading.value || totalImagesCount.value === 0 || processing.value) return

  switch (e.key) {
    case '1':
      handleCategoryAction('temple')
      break
    case '2':
      handleCategoryAction('idol')
      break
    case '3':
      handleCategoryAction('detail')
      break
    case '4':
      handleCategoryAction('social')
      break
    case '5':
    case 'Delete':
    case 'Backspace':
      handleCategoryAction('skip')
      break
    case 'ArrowLeft':
      if (mode.value === 'review') prevItem()
      break
    case 'ArrowRight':
      if (mode.value === 'review') nextItem()
      break
  }
}

onMounted(() => {
  loadAllData()
  window.addEventListener('keydown', handleKeyDown)
})

onUnmounted(() => {
  window.removeEventListener('keydown', handleKeyDown)
})
</script>

<style scoped>
.curator-container {
  min-height: 100vh;
  background-color: #0d0f14;
  color: var(--text);
  padding-bottom: 4rem;
}

.curator-header {
  background: var(--bg-card);
  border-bottom: 1px solid var(--border);
  padding: 1rem 0;
  position: sticky;
  top: 0;
  z-index: 100;
}
.header-inner {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 1.5rem;
}
.brand {
  display: flex;
  align-items: center;
  gap: 0.75rem;
}
.brand h1 {
  font-family: var(--font-sans);
  font-size: 1.2rem;
  font-weight: 600;
  color: #fff;
  margin: 0;
}

/* Mode Switcher Tabs */
.mode-tabs {
  display: flex;
  background: rgba(255,255,255,0.03);
  border: 1px solid var(--border);
  border-radius: 8px;
  padding: 0.25rem;
}
.tab-btn {
  background: transparent;
  border: none;
  color: var(--text-muted);
  font-family: var(--font-sans);
  font-size: 0.85rem;
  font-weight: 500;
  padding: 0.5rem 1rem;
  border-radius: 6px;
  cursor: pointer;
  transition: all 0.2s ease;
}
.tab-btn.active {
  background: var(--gold-muted);
  color: var(--gold);
  border: 1px solid rgba(212,175,55,0.2);
}

/* Review Filters */
.review-filters {
  background: var(--bg-card);
  border: 1px solid var(--border);
  border-radius: 10px;
  padding: 1rem;
  margin-bottom: 2rem;
  display: flex;
  align-items: center;
  gap: 1rem;
  flex-wrap: wrap;
}
.filter-label {
  font-size: 0.9rem;
  color: var(--text-muted);
  font-weight: 500;
}
.filter-tab {
  background: rgba(255,255,255,0.02);
  border: 1px solid var(--border);
  color: var(--text-muted);
  padding: 0.4rem 0.9rem;
  border-radius: 30px;
  font-size: 0.8rem;
  cursor: pointer;
  transition: all 0.2s ease;
}
.filter-tab.active {
  background: var(--gold-muted);
  border-color: var(--gold);
  color: var(--gold);
}

.main-content {
  margin-top: 2rem;
}

/* State cards */
.state-card {
  background: var(--bg-card);
  border: 1px solid var(--border);
  border-radius: var(--radius);
  padding: 4rem 2rem;
  text-align: center;
  max-width: 500px;
  margin: 0 auto;
}
.spinner {
  width: 40px;
  height: 40px;
  border: 3px solid rgba(212,175,55,0.1);
  border-top-color: var(--gold);
  border-radius: 50%;
  animation: spin 1s infinite linear;
  margin: 0 auto 1.5rem;
}
@keyframes spin {
  to { transform: rotate(360deg); }
}

.empty-icon {
  font-size: 4rem;
  display: block;
  margin-bottom: 1.5rem;
}
.empty-card h2 {
  font-size: 1.5rem;
  color: #fff;
  margin-bottom: 0.5rem;
}
.empty-card p {
  color: var(--text-muted);
  margin-bottom: 2rem;
}
.empty-card .btn {
  margin-top: 0.5rem;
}

/* Workspace layout */
.workspace-grid {
  display: grid;
  grid-template-columns: 1.3fr 1fr;
  gap: 3rem;
  align-items: start;
}

/* Visual Panel */
.visual-panel {
  background: var(--bg-card);
  border: 1px solid var(--border);
  border-radius: var(--radius);
  padding: 1.5rem;
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}
.image-wrapper {
  position: relative;
  width: 100%;
  aspect-ratio: 4/3;
  background: #06080b;
  border-radius: 8px;
  overflow: hidden;
  display: flex;
  align-items: center;
  justify-content: center;
  border: 1px solid rgba(255,255,255,0.03);
}
.uncurated-image {
  max-width: 100%;
  max-height: 100%;
  object-fit: contain;
}
.image-placeholder {
  position: absolute;
  inset: 0;
  background: #06080b;
  display: flex;
  align-items: center;
  justify-content: center;
}
.image-meta {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 0.9rem;
}
.filename {
  font-family: monospace;
  color: var(--text-muted);
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  max-width: 50%;
}
.meta-right {
  display: flex;
  align-items: center;
  gap: 1rem;
}
.current-cat-badge {
  background: rgba(255,255,255,0.05);
  border: 1px solid var(--border);
  padding: 0.25rem 0.55rem;
  border-radius: 6px;
  font-size: 0.75rem;
  text-transform: capitalize;
  color: var(--text-muted);
}
.progress-indicator {
  color: var(--gold);
  font-weight: 500;
}

/* Review Navigation Row */
.review-nav {
  display: flex;
  justify-content: space-between;
  align-items: center;
  border-top: 1px solid var(--border);
  padding-top: 1rem;
  margin-top: 0.5rem;
}
.nav-count {
  font-size: 0.85rem;
  color: var(--text-muted);
}
.btn-xs {
  font-size: 0.75rem;
  padding: 0.35rem 0.75rem;
  border-radius: 6px;
}

/* Control Panel */
.control-panel {
  background: var(--bg-card);
  border: 1px solid var(--border);
  border-radius: var(--radius);
  padding: 2.5rem;
}
.control-panel h2 {
  font-size: 1.4rem;
  font-weight: 600;
  color: #fff;
  margin-bottom: 0.5rem;
}
.instruction {
  color: var(--text-muted);
  font-size: 0.9rem;
  line-height: 1.5;
  margin-bottom: 2rem;
}

.button-stack {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.btn-curate {
  display: flex;
  align-items: center;
  width: 100%;
  padding: 1.1rem 1.5rem;
  border: 1px solid var(--border);
  border-radius: 12px;
  background: rgba(255,255,255,0.02);
  color: var(--text);
  font-family: var(--font-sans);
  font-size: 1rem;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s ease;
  outline: none;
}
.btn-curate.highlighted {
  border-color: rgba(212,175,55,0.4);
  background: rgba(212,175,55,0.08);
}
.key-hint {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 28px;
  height: 28px;
  background: rgba(255,255,255,0.05);
  border: 1px solid var(--border);
  border-radius: 6px;
  font-size: 0.85rem;
  font-weight: bold;
  color: var(--text-muted);
  margin-right: 1.25rem;
  transition: all 0.2s ease;
}

.btn-temple:hover {
  border-color: rgba(212,175,55,0.4);
  background: rgba(212,175,55,0.05);
  color: var(--gold-light);
}
.btn-temple:hover .key-hint {
  border-color: var(--gold);
  color: var(--gold);
  background: var(--gold-muted);
}

.btn-idol:hover {
  border-color: rgba(99,102,241,0.4);
  background: rgba(99,102,241,0.05);
  color: #a5b4fc;
}
.btn-idol:hover .key-hint {
  border-color: #6366f1;
  color: #818cf8;
  background: rgba(99,102,241,0.15);
}

.btn-detail:hover {
  border-color: rgba(20,184,166,0.4);
  background: rgba(20,184,166,0.05);
  color: #99f6e4;
}
.btn-detail:hover .key-hint {
  border-color: #14b8a6;
  color: #2dd4bf;
  background: rgba(20,184,166,0.15);
}

.btn-social:hover {
  border-color: rgba(249,115,22,0.4);
  background: rgba(249,115,22,0.05);
  color: #fed7aa;
}
.btn-social:hover .key-hint {
  border-color: #f97316;
  color: #fb923c;
  background: rgba(249,115,22,0.15);
}

.separator {
  text-align: center;
  color: rgba(255,255,255,0.15);
  font-size: 0.8rem;
  text-transform: uppercase;
  letter-spacing: 2px;
  margin: 0.5rem 0;
}

.btn-skip {
  border-color: rgba(239,68,68,0.2);
  color: var(--text-muted);
}
.btn-skip:hover {
  border-color: rgba(239,68,68,0.5);
  background: rgba(239,68,68,0.05);
  color: #fca5a5;
}
.btn-skip:hover .key-hint {
  border-color: #ef4444;
  color: #f87171;
  background: rgba(239,68,68,0.15);
}

.btn-curate:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

/* Shortcuts Legend */
.shortcuts-legend {
  margin-top: 3rem;
  border-top: 1px solid var(--border);
  padding-top: 1.5rem;
}
.shortcuts-legend h3 {
  font-size: 0.9rem;
  font-weight: 600;
  color: #fff;
  margin-bottom: 0.75rem;
}
.shortcut-list {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 0.75rem;
}
.shortcut-item {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  font-size: 0.8rem;
  color: var(--text-muted);
}
.shortcut-item span {
  display: inline-block;
  padding: 0.15rem 0.4rem;
  background: rgba(255,255,255,0.05);
  border: 1px solid var(--border);
  border-radius: 4px;
  font-family: monospace;
  font-weight: bold;
}

@media (max-width: 1024px) {
  .workspace-grid {
    grid-template-columns: 1fr;
    gap: 2rem;
  }
}
</style>
