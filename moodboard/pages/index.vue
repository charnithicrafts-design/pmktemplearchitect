<template>
  <div>
    <!-- HERO -->
    <section class="hero">
      <div class="hero-bg">
        <img src="/gallery/img_014.jpeg" alt="PMK Temple Architecture" class="hero-img" />
        <div class="hero-overlay" />
      </div>
      <div class="hero-content container">
        <p class="section-label reveal">HH 44th JEEYAR'S — Sthapathi for Generations</p>
        <h1 class="reveal reveal-delay-1">Divine Craftsmanship<br>in Stone</h1>
        <div class="gold-line reveal reveal-delay-2" />
        <p class="hero-desc reveal reveal-delay-2">Master temple architects and stone carpenters specializing in South & North Indian style temple construction and sacred idol creation.</p>
        <div class="hero-ctas reveal reveal-delay-3">
          <NuxtLink to="/gallery" class="btn btn-primary">View Our Work</NuxtLink>
          <NuxtLink to="/contact" class="btn btn-outline">Start a Project</NuxtLink>
        </div>
      </div>
      <div class="scroll-hint">
        <div class="mouse"><div class="dot" /></div>
      </div>
    </section>

    <!-- HIGHLIGHTS -->
    <section class="highlights">
      <div class="container highlights-grid">
        <div v-for="(h, i) in highlights" :key="i" class="highlight-card reveal" :class="`reveal-delay-${i+1}`">
          <span class="h-icon">{{ h.icon }}</span>
          <strong>{{ h.value }}</strong>
          <p>{{ h.label }}</p>
        </div>
      </div>
    </section>

    <!-- INTRO -->
    <section class="intro section-pad">
      <div class="container intro-grid">
        <div class="intro-images reveal">
          <img src="/gallery/img_002.jpeg" alt="Temple Work" class="intro-img-main" />
          <img src="/gallery/img_004.jpeg" alt="Idol Work" class="intro-img-side" />
        </div>
        <div class="intro-text">
          <span class="section-label reveal">Who We Are</span>
          <h2 class="section-title reveal reveal-delay-1">The Master Builder</h2>
          <div class="gold-line reveal reveal-delay-1" />
          <h3 class="founder reveal reveal-delay-2">N. Prabhu Sthabathiyar<br><span class="tamil">N. பிரபு ஸ்தபதியார்</span></h3>
          <p class="reveal reveal-delay-2">At P.M.K. Temple Architect, we breathe life into stone. Every temple we construct, every idol we carve, follows strict Agama Shastra traditions passed down through generations of master Sthapathis.</p>
          <blockquote class="reveal reveal-delay-3">"Agama Vithipadi Seithu Tharapadam"</blockquote>
          <NuxtLink to="/about" class="btn btn-outline reveal reveal-delay-3">Learn More About Us</NuxtLink>
        </div>
      </div>
    </section>

    <!-- SERVICES SNAPSHOT -->
    <section class="services-snap section-pad dark-section">
      <div class="container">
        <div class="section-head reveal">
          <span class="section-label">What We Do</span>
          <h2 class="section-title">Our Core Expertise</h2>
          <p class="section-sub">Specializing in diverse architectural styles and sacred arts</p>
        </div>
        <div class="services-grid">
          <NuxtLink v-for="(s, i) in services" :key="i" to="/services" class="service-card reveal" :class="`reveal-delay-${i+1}`">
            <div class="s-icon-wrap">{{ s.icon }}</div>
            <h3>{{ s.title }}</h3>
            <p>{{ s.desc }}</p>
            <span class="s-arrow">→</span>
          </NuxtLink>
        </div>
      </div>
    </section>

    <!-- GALLERY PREVIEW -->
    <section class="gallery-preview section-pad">
      <div class="container">
        <div class="section-head reveal">
          <span class="section-label">Our Portfolio</span>
          <h2 class="section-title">Recent Work</h2>
        </div>
        <div class="preview-mosaic">
          <div v-for="(img, i) in previewImages" :key="i" class="mosaic-cell reveal" :class="[`cell-${i}`, `reveal-delay-${(i%4)+1}`]">
            <img :src="img" :alt="`Temple work ${i+1}`" loading="lazy" />
          </div>
        </div>
        <div class="gallery-cta reveal">
          <NuxtLink to="/gallery" class="btn btn-primary">View Full Gallery →</NuxtLink>
        </div>
      </div>
    </section>

    <!-- TESTIMONIAL / BADGE -->
    <section class="badge-section section-pad dark-section">
      <div class="container badge-inner">
        <div class="badge-text reveal">
          <span class="section-label">A Legacy of Devotion</span>
          <h2 class="section-title">The Only Temple in the World<br>Dedicated to Dasaavatharas</h2>
          <p>The Srirangam Agopila Math temple, with ten Kalasams — exclusively built by P.M.K. Temple Architect.</p>
          <NuxtLink to="/gallery" class="btn btn-outline">See the Project</NuxtLink>
        </div>
        <div class="badge-img reveal reveal-delay-2">
          <img src="/gallery/img_014.jpeg" alt="Srirangam Agopila Math" />
        </div>
      </div>
    </section>

    <!-- CONTACT STRIP -->
    <section class="cta-strip">
      <div class="container cta-strip-inner reveal">
        <div>
          <h2>Ready to Build Something Sacred?</h2>
          <p>Let's discuss your vision and bring it to life with ancient craftsmanship.</p>
        </div>
        <NuxtLink to="/contact" class="btn btn-primary">Get in Touch</NuxtLink>
      </div>
    </section>
  </div>
</template>

<script setup>
useHead({ title: 'P.M.K. Temple Architect | Divine Craftsmanship in Stone' })

const highlights = [
  { icon: '🏛️', value: 'Generations', label: 'of Sthapathi Legacy' },
  { icon: '🗿', value: '100+', label: 'Temples & Idols Crafted' },
  { icon: '📜', value: 'Agama', label: 'Shastra Certified Work' },
  { icon: '🌍', value: 'Pan India', label: 'Projects Completed' },
]

const services = [
  { icon: '🏛️', title: 'South Indian Style', desc: 'Towering Gopurams, Dravidian pillars, and intricate carvings reflecting rich Southern heritage.' },
  { icon: '🏯', title: 'North Indian Style', desc: 'Majestic Nagara Shikharas, beautiful mandapas, and exquisite stone artistry.' },
  { icon: '🗿', title: 'Idol Creation', desc: 'Sacred deities carved from premium stone following traditional iconographic proportions.' },
  { icon: '🏗️', title: 'Temple Contractor', desc: 'End-to-end execution ensuring quality materials and masterful craftsmanship.' },
]

const previewImages = [
  '/gallery/img_002.jpeg',
  '/gallery/img_002.jpeg',
  '/gallery/img_004.jpeg',
  '/gallery/img_008.jpeg',
  '/gallery/img_008.jpeg',
  '/gallery/img_007.jpeg',
  '/gallery/img_006.jpeg',
  '/gallery/img_006.jpeg',
]

onMounted(() => {
  const obs = new IntersectionObserver((entries) => {
    entries.forEach(e => { if (e.isIntersecting) { e.target.classList.add('in-view'); obs.unobserve(e.target) } })
  }, { threshold: 0.1 })
  document.querySelectorAll('.reveal').forEach(el => obs.observe(el))
})
</script>

<style scoped>
/* HERO */
.hero {
  position: relative;
  height: 100vh;
  min-height: 600px;
  display: flex;
  align-items: center;
  overflow: hidden;
}
.hero-bg { position: absolute; inset: 0; }
.hero-img { width: 100%; height: 100%; object-fit: cover; }
.hero-overlay {
  position: absolute; inset: 0;
  background: linear-gradient(135deg, rgba(13,15,20,0.85) 0%, rgba(13,15,20,0.5) 60%, rgba(13,15,20,0.75) 100%);
}
.hero-content {
  position: relative;
  z-index: 1;
  max-width: 700px;
}
.hero-content h1 {
  font-size: clamp(2.5rem, 5.5vw, 4rem);
  color: #fff;
  margin: 0.75rem 0 1rem;
}
.hero-desc { color: var(--text-muted); font-size: 1.1rem; max-width: 520px; margin-bottom: 2rem; }
.hero-ctas { display: flex; gap: 1rem; flex-wrap: wrap; }

.scroll-hint {
  position: absolute;
  bottom: 2rem; left: 50%;
  transform: translateX(-50%);
  z-index: 1;
}
.mouse {
  width: 26px; height: 42px;
  border: 2px solid rgba(255,255,255,0.3);
  border-radius: 15px;
  position: relative;
  margin: 0 auto;
}
.dot {
  width: 5px; height: 5px;
  background: var(--gold);
  border-radius: 50%;
  position: absolute;
  top: 8px; left: 50%;
  transform: translateX(-50%);
  animation: scrollDot 2s infinite;
}
@keyframes scrollDot {
  0% { opacity: 1; top: 8px; }
  100% { opacity: 0; top: 24px; }
}

/* HIGHLIGHTS */
.highlights {
  background: #090b0f;
  border-bottom: 1px solid var(--border);
  padding: 2rem 0;
}
.highlights-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 1px;
}
.highlight-card {
  text-align: center;
  padding: 2rem 1rem;
  border-left: 1px solid var(--border);
}
.highlight-card:first-child { border-left: none; }
.h-icon { font-size: 1.8rem; display: block; margin-bottom: 0.5rem; }
.highlight-card strong { display: block; font-size: 1.6rem; color: var(--gold); font-family: var(--font-serif); margin-bottom: 0.25rem; }
.highlight-card p { color: var(--text-muted); font-size: 0.85rem; }

/* INTRO */
.section-pad { padding: 6rem 0; }
.dark-section { background: #090b0f; }

.intro-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 4rem;
  align-items: center;
}
.intro-images {
  position: relative;
  height: 500px;
}
.intro-img-main {
  width: 80%;
  height: 380px;
  object-fit: cover;
  border-radius: var(--radius);
  position: absolute;
  top: 0; left: 0;
  box-shadow: var(--shadow-lg);
  border: 1px solid var(--border);
}
.intro-img-side {
  width: 55%;
  height: 260px;
  object-fit: cover;
  border-radius: var(--radius);
  position: absolute;
  bottom: 0; right: 0;
  box-shadow: var(--shadow-lg);
  border: 3px solid var(--bg);
}
.founder { font-family: var(--font-sans); font-size: 1.15rem; font-weight: 600; color: var(--gold); margin: 1rem 0; }
.tamil { font-weight: 300; color: var(--text-muted); font-size: 0.95rem; }
.intro-text p { color: var(--text-muted); margin-bottom: 1.25rem; }
blockquote {
  border-left: 3px solid var(--gold);
  padding: 0.75rem 1rem;
  color: var(--gold-light);
  font-style: italic;
  font-size: 1.05rem;
  background: var(--gold-muted);
  border-radius: 0 8px 8px 0;
  margin-bottom: 1.75rem;
}

/* SERVICES */
.section-head { margin-bottom: 3rem; }
.services-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 1.5rem;
}
.service-card {
  background: var(--bg-card);
  border: 1px solid var(--border);
  border-radius: var(--radius);
  padding: 2rem 1.5rem;
  transition: var(--transition);
  display: block;
  position: relative;
  overflow: hidden;
}
.service-card::before {
  content: '';
  position: absolute;
  bottom: 0; left: 0;
  width: 100%; height: 3px;
  background: var(--gold);
  transform: scaleX(0);
  transform-origin: left;
  transition: var(--transition);
}
.service-card:hover { border-color: rgba(212,175,55,0.3); transform: translateY(-6px); box-shadow: var(--shadow-lg); }
.service-card:hover::before { transform: scaleX(1); }
.s-icon-wrap { font-size: 2.5rem; margin-bottom: 1.25rem; }
.service-card h3 { font-family: var(--font-sans); font-size: 1rem; font-weight: 600; color: #fff; margin-bottom: 0.75rem; }
.service-card p { color: var(--text-muted); font-size: 0.875rem; line-height: 1.6; }
.s-arrow { display: block; color: var(--gold); margin-top: 1.25rem; font-size: 1.2rem; transition: var(--transition); }
.service-card:hover .s-arrow { transform: translateX(6px); }

/* GALLERY PREVIEW */
.preview-mosaic {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  grid-template-rows: 220px 220px;
  gap: 0.75rem;
  margin-bottom: 2rem;
}
.mosaic-cell { border-radius: var(--radius); overflow: hidden; }
.mosaic-cell img { width: 100%; height: 100%; object-fit: cover; transition: transform 0.5s ease; }
.mosaic-cell:hover img { transform: scale(1.06); }
.cell-0 { grid-column: span 2; grid-row: span 2; }
.gallery-cta { text-align: center; }

/* BADGE */
.badge-inner {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 4rem;
  align-items: center;
}
.badge-text p { color: var(--text-muted); margin: 1rem 0 2rem; }
.badge-img img { width: 100%; height: 420px; object-fit: cover; border-radius: var(--radius); box-shadow: var(--shadow-lg); }

/* CTA STRIP */
.cta-strip {
  background: linear-gradient(135deg, rgba(212,175,55,0.12), rgba(212,175,55,0.04));
  border-top: 1px solid rgba(212,175,55,0.2);
  border-bottom: 1px solid rgba(212,175,55,0.2);
  padding: 4rem 0;
}
.cta-strip-inner {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 2rem;
  flex-wrap: wrap;
}
.cta-strip h2 { font-size: 1.8rem; color: #fff; margin-bottom: 0.5rem; }
.cta-strip p { color: var(--text-muted); }

@media (max-width: 1024px) {
  .services-grid { grid-template-columns: repeat(2, 1fr); }
  .preview-mosaic { grid-template-columns: repeat(2, 1fr); grid-template-rows: auto; }
  .cell-0 { grid-column: span 2; grid-row: span 1; }
}
@media (max-width: 768px) {
  .highlights-grid { grid-template-columns: repeat(2, 1fr); }
  .intro-grid, .badge-inner { grid-template-columns: 1fr; }
  .intro-images { height: 300px; margin-bottom: 2rem; }
  .intro-img-main { width: 85%; height: 260px; }
  .intro-img-side { width: 50%; height: 180px; }
  .cta-strip-inner { flex-direction: column; text-align: center; }
}
@media (max-width: 480px) {
  .highlights-grid { grid-template-columns: 1fr 1fr; }
  .services-grid { grid-template-columns: 1fr; }
}
</style>
