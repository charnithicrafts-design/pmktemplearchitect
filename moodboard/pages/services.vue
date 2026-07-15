<template>
  <div>
    <section class="page-hero">
      <div class="page-hero-bg">
        <img src="/gallery/img_002.jpeg" alt="Services" />
        <div class="page-hero-overlay" />
      </div>
      <div class="container page-hero-content">
        <span class="section-label">What We Offer</span>
        <h1 class="section-title">Our Services</h1>
        <p class="section-sub">From conception to consecration — we handle every aspect of sacred construction.</p>
      </div>
    </section>

    <section class="services-section section-pad">
      <div class="container">
        <div v-for="(s, i) in services" :key="i" class="service-row reveal" :class="{ reverse: i % 2 !== 0 }">
          <div class="s-image">
            <img :src="s.image" :alt="s.title" />
          </div>
          <div class="s-text">
            <span class="s-num">0{{ i + 1 }}</span>
            <h2 class="section-title">{{ s.title }}</h2>
            <div class="gold-line" />
            <p>{{ s.desc }}</p>
            <ul class="s-features">
              <li v-for="f in s.features" :key="f">
                <span class="check">✦</span> {{ f }}
              </li>
            </ul>
            <NuxtLink to="/contact" class="btn btn-outline">Start This Project</NuxtLink>
          </div>
        </div>
      </div>
    </section>

    <!-- PROCESS -->
    <section class="process-section section-pad dark-section">
      <div class="container">
        <div class="section-head reveal">
          <span class="section-label">How We Work</span>
          <h2 class="section-title">Our Process</h2>
          <p class="section-sub">A transparent, time-tested approach to every project</p>
        </div>
        <div class="process-grid">
          <div v-for="(step, i) in process" :key="i" class="process-step reveal" :class="`reveal-delay-${i+1}`">
            <div class="step-num">{{ String(i+1).padStart(2,'0') }}</div>
            <h3>{{ step.title }}</h3>
            <p>{{ step.desc }}</p>
          </div>
        </div>
      </div>
    </section>
  </div>
</template>

<script setup>
useHead({ title: 'Services | P.M.K. Temple Architect' })

const services = [
  {
    title: 'South Indian Style Temples',
    image: '/gallery/img_002.jpeg',
    desc: 'We are masters of Dravidian architecture — the towering Gopurams, intricate mandapas, and elaborately carved pillars that define South Indian temple heritage.',
    features: ['Towering Gopuram construction', 'Multi-tiered Vimanam design', 'Dravidian pillar carvings', 'Agama-compliant sanctum sanctorum', 'Colour and iconographic detailing'],
  },
  {
    title: 'North Indian Style Temples',
    image: '/gallery/img_014.jpeg',
    desc: 'Our team crafts majestic Nagara-style temples featuring soaring Shikharas, beautifully carved mandapas, and devotional stonework that captures the essence of Northern sacred architecture.',
    features: ['Nagara-style Shikhara', 'Ornate Mandapa construction', 'Amalaka and Kalasha finials', 'Sandstone and granite carving', 'Cross-regional design consultation'],
  },
  {
    title: 'Idol & Sculpture Creation',
    image: '/gallery/img_006.jpeg',
    desc: 'Each deity we sculpt is carved from premium quality stone, following precise iconographic proportions defined in Agamic texts. These are not mere statues — they are living vessels of the divine.',
    features: ['Traditional iconographic proportions', 'Premium granite and marble carving', 'From miniature vigrahas to monumental idols', 'Panchadhatu metal work consultation', 'Pratishtha ceremony coordination'],
  },
  {
    title: 'Temple Contracting & Renovation',
    image: '/gallery/img_012.jpeg',
    desc: 'We manage complete temple construction projects end-to-end — from site planning and material procurement to construction supervision and final consecration.',
    features: ['Complete project management', 'Material sourcing and quality control', 'Licensed structural work', 'Temple renovation and restoration', 'On-site Sthapathi supervision'],
  },
]

const process = [
  { title: 'Consultation', desc: 'We meet with your trust or committee to understand the vision, location, and Agamic requirements for the project.' },
  { title: 'Design & Planning', desc: 'Our Sthapathi creates detailed plans, drawings, and material estimates following traditional architectural texts.' },
  { title: 'Material Procurement', desc: 'Only the finest grade stone is selected. We source from trusted quarries with decades of experience.' },
  { title: 'Construction', desc: 'Master craftsmen work under continuous supervision to bring the design to life, stone by sacred stone.' },
  { title: 'Detailing & Painting', desc: 'Intricate carvings, stucco work, and traditional colour application are applied to complete the divine aesthetic.' },
  { title: 'Consecration Support', desc: 'We coordinate with priests for the Kumbabishekam or Pratishtha ceremony, ensuring everything is Agama-compliant.' },
]

onMounted(() => {
  const obs = new IntersectionObserver((entries) => {
    entries.forEach(e => { if (e.isIntersecting) { e.target.classList.add('in-view'); obs.unobserve(e.target) } })
  }, { threshold: 0.08 })
  document.querySelectorAll('.reveal').forEach(el => obs.observe(el))
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

.section-pad { padding: 6rem 0; }
.dark-section { background: #090b0f; }
.section-head { margin-bottom: 3rem; }

.service-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 4rem;
  align-items: center;
  margin-bottom: 6rem;
}
.service-row.reverse { direction: rtl; }
.service-row.reverse > * { direction: ltr; }
.s-image img { width: 100%; height: 420px; object-fit: cover; border-radius: var(--radius); box-shadow: 0 20px 60px rgba(0,0,0,0.5); }
.s-num { font-size: 4rem; font-family: var(--font-serif); color: var(--gold-muted); font-weight: 700; line-height: 1; display: block; margin-bottom: 0.5rem; }
.s-text p { color: var(--text-muted); margin-bottom: 1.5rem; }
.s-features { margin-bottom: 2rem; }
.s-features li { color: var(--text-muted); font-size: 0.9rem; margin-bottom: 0.5rem; display: flex; align-items: flex-start; gap: 0.75rem; }
.check { color: var(--gold); flex-shrink: 0; }

.process-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 1.5rem;
}
.process-step {
  background: var(--bg-card);
  border: 1px solid var(--border);
  border-radius: var(--radius);
  padding: 2rem;
  transition: var(--transition);
  position: relative;
  overflow: hidden;
}
.process-step:hover { border-color: rgba(212,175,55,0.25); }
.step-num {
  font-size: 3.5rem;
  font-family: var(--font-serif);
  color: var(--gold-muted);
  font-weight: 700;
  line-height: 1;
  margin-bottom: 1rem;
}
.process-step h3 { font-family: var(--font-sans); font-size: 1rem; font-weight: 600; color: #fff; margin-bottom: 0.75rem; }
.process-step p { color: var(--text-muted); font-size: 0.875rem; line-height: 1.6; }

@media (max-width: 768px) {
  .service-row, .service-row.reverse { grid-template-columns: 1fr; direction: ltr; }
  .process-grid { grid-template-columns: 1fr; }
}
@media (max-width: 480px) { .process-grid { grid-template-columns: 1fr; } }
</style>
