<template>
  <div class="curator-container">
    <div class="curator-header">
      <div class="container header-inner">
        <div class="brand">
          <span class="logo-mark">PMK</span>
          <h1>Image Curation Dashboard</h1>
        </div>
        <NuxtLink to="/gallery" class="btn btn-outline btn-sm">Go to Gallery →</NuxtLink>
      </div>
    </div>

    <div class="container main-content">
      <!-- Loading state -->
      <div v-if="loading" class="state-card loading-card">
        <div class="spinner" />
        <p>Loading uncurated images...</p>
      </div>

      <!-- Empty state -->
      <div v-else-if="images.length === 0" class="state-card empty-card">
        <span class="empty-icon">🎉</span>
        <h2>All Done!</h2>
        <p>There are no more images to curate in <code>public/unzipped_raw/</code>.</p>
        <NuxtLink to="/gallery" class="btn btn-primary">View the Live Gallery</NuxtLink>
      </div>

      <!-- Curator Workspace -->
      <div v-else class="workspace-grid">
        <!-- Visual Panel -->
        <div class="visual-panel">
          <div class="image-wrapper">
            <img 
              :src="`/unzipped_raw/${currentImage}`" 
              :alt="currentImage" 
              class="uncurated-image"
              @load="imageLoaded = true"
            />
            <div v-if="!imageLoaded" class="image-placeholder">
              <div class="spinner" />
            </div>
          </div>
          <div class="image-meta">
            <span class="filename">{{ currentImage }}</span>
            <span class="progress-indicator">Image {{ currentIndex + 1 }} of {{ images.length }}</span>
          </div>
        </div>

        <!-- Control Panel -->
        <div class="control-panel">
          <h2>Select Category</h2>
          <p class="instruction">Choose the appropriate category for this image. You can also use the keyboard shortcuts (1-4) for rapid curation.</p>

          <div class="button-stack">
            <button 
              class="btn-curate btn-temple" 
              :disabled="processing"
              @click="curate('temple')"
            >
              <span class="key-hint">1</span>
              <span class="label">🕌 Temple Architecture</span>
            </button>

            <button 
              class="btn-curate btn-idol" 
              :disabled="processing"
              @click="curate('idol')"
            >
              <span class="key-hint">2</span>
              <span class="label">🗿 Idol / Sculpture</span>
            </button>

            <button 
              class="btn-curate btn-detail" 
              :disabled="processing"
              @click="curate('detail')"
            >
              <span class="key-hint">3</span>
              <span class="label">🔍 Fine Stone Details</span>
            </button>

            <button 
              class="btn-curate btn-social" 
              :disabled="processing"
              @click="curate('social')"
            >
              <span class="key-hint">4</span>
              <span class="label">🎉 Events & Social</span>
            </button>

            <div class="separator">or</div>

            <button 
              class="btn-curate btn-skip" 
              :disabled="processing"
              @click="curate('skip')"
            >
              <span class="key-hint">5</span>
              <span class="label">🗑️ Skip / Delete Image</span>
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
              <div class="shortcut-item"><span>5</span> / <span>Del</span> Skip</div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
useHead({ title: 'Curation | P.M.K. Temple Architect' })

const images = ref([])
const currentIndex = ref(0)
const loading = ref(true)
const processing = ref(false)
const imageLoaded = ref(false)

const currentImage = computed(() => images.value[currentIndex.value] || '')

// Fetch list of uncurated images
async function fetchImages() {
  loading.value = true
  try {
    const data = await $fetch('/api/uncurated')
    images.value = data
    currentIndex.value = 0
    imageLoaded.value = false
  } catch (err) {
    console.error('Failed to load uncurated images:', err)
  } finally {
    loading.value = false
  }
}

// Curate the current image
async function curate(category) {
  if (processing.value || !currentImage.value) return
  
  processing.value = true
  imageLoaded.value = false
  
  try {
    const res = await $fetch('/api/curate', {
      method: 'POST',
      body: {
        filename: currentImage.value,
        category: category
      }
    })

    if (res.success) {
      // Remove the item from list locally
      images.value.splice(currentIndex.value, 1)
      
      // If we ran out of images, reset index
      if (currentIndex.value >= images.value.length) {
        currentIndex.value = Math.max(0, images.value.length - 1)
      }
    }
  } catch (err) {
    console.error('Failed to curate image:', err)
    alert(`Error: ${err.statusMessage || 'Something went wrong'}`)
  } finally {
    processing.value = false
  }
}

// Keyboard navigation listener
function handleKeyDown(e) {
  if (loading.value || images.value.length === 0 || processing.value) return

  switch (e.key) {
    case '1':
      curate('temple')
      break
    case '2':
      curate('idol')
      break
    case '3':
      curate('detail')
      break
    case '4':
      curate('social')
      break
    case '5':
    case 'Delete':
    case 'Backspace':
      curate('skip')
      break
  }
}

onMounted(() => {
  fetchImages()
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

.main-content {
  margin-top: 3rem;
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
  max-width: 60%;
}
.progress-indicator {
  color: var(--gold);
  font-weight: 500;
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
