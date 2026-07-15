<template>
  <div>
    <!-- PAGE HERO -->
    <section class="page-hero">
      <div class="page-hero-bg">
        <img src="/gallery/img_014.jpeg" alt="About PMK" />
        <div class="page-hero-overlay" />
      </div>
      <div class="container page-hero-content">
        <span class="section-label">Our Story</span>
        <h1 class="section-title">About P.M.K. Temple Architect</h1>
        <p class="section-sub">A lineage of master craftsmen serving the divine — for generations.</p>
      </div>
    </section>

    <!-- STORY -->
    <section class="story-section section-pad">
      <div class="container story-grid">
        <div class="story-text">
          <span class="section-label reveal">The Sthapathi Legacy</span>
          <h2 class="section-title reveal reveal-delay-1">N. Prabhu Sthabathiyar</h2>
          <h3 class="tamil-name reveal reveal-delay-1">N. பிரபு ஸ்தபதியார்</h3>
          <div class="gold-line reveal reveal-delay-2" />
          <p class="reveal reveal-delay-2">Rooted in the ancient tradition of temple architecture, P.M.K. Temple Architect is led by N. Prabhu Sthabathiyar, a master Sthapathi who has devoted his life to the sacred art of stone craftsmanship.</p>
          <p class="reveal reveal-delay-2">The title "Sthapathi" signifies a master architect of temples — a tradition with over 5,000 years of history in the Indian subcontinent, codified in texts like the <em>Manasara</em> and <em>Mayamata</em>.</p>
          <blockquote class="reveal reveal-delay-3">"Agama Vithipadi Seithu Tharapadam" — Delivered according to the sacred Agama codes</blockquote>
        </div>
        <div class="story-images reveal reveal-delay-2">
          <img src="/gallery/img_001.jpeg" alt="PMK Temple Work" />
        </div>
      </div>
    </section>

    <!-- VALUES -->
    <section class="values-section section-pad dark-section">
      <div class="container">
        <div class="section-head reveal">
          <span class="section-label">What Drives Us</span>
          <h2 class="section-title">Our Core Values</h2>
        </div>
        <div class="values-grid">
          <div v-for="(v, i) in values" :key="i" class="value-card reveal" :class="`reveal-delay-${i+1}`">
            <div class="v-icon">{{ v.icon }}</div>
            <h3>{{ v.title }}</h3>
            <p>{{ v.desc }}</p>
          </div>
        </div>
      </div>
    </section>

    <!-- MILESTONES -->
    <section class="milestones-section section-pad">
      <div class="container">
        <div class="section-head reveal">
          <span class="section-label">Our Journey</span>
          <h2 class="section-title">Key Milestones</h2>
        </div>
        <div class="timeline">
          <div v-for="(m, i) in milestones" :key="i" class="timeline-item reveal" :class="`reveal-delay-${(i%3)+1}`">
            <div class="t-dot" />
            <div class="t-content">
              <span class="t-year">{{ m.year }}</span>
              <h4>{{ m.title }}</h4>
              <p>{{ m.desc }}</p>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- FEATURED PROJECT -->
    <section class="featured-section section-pad dark-section">
      <div class="container featured-inner">
        <div class="featured-img reveal">
          <img src="/gallery/img_015.jpeg" alt="Srirangam Agopila Math" />
        </div>
        <div class="featured-text">
          <span class="section-label reveal">Landmark Project</span>
          <h2 class="section-title reveal reveal-delay-1">Srirangam Agopila Math</h2>
          <div class="gold-line reveal reveal-delay-1" />
          <p class="reveal reveal-delay-2">The only temple in the world dedicated to the Dasaavatharas — ten Kalasams were constructed on this masterpiece, exclusively built by P.M.K. Temple Architect under the guidance of HH 44th Jeeyar.</p>
          <p class="reveal reveal-delay-2">This monumental project stands as a testament to our unwavering commitment to Agamic tradition and architectural perfection.</p>
          <NuxtLink to="/gallery" class="btn btn-primary reveal reveal-delay-3">View in Gallery →</NuxtLink>
        </div>
      </div>
    </section>
  </div>
</template>

<script setup>
useHead({ title: 'About | P.M.K. Temple Architect' })

const values = [
  { icon: '📜', title: 'Agamic Integrity', desc: 'Every project strictly follows Agama Shastra principles — the ancient sacred codes of temple construction.' },
  { icon: '🪨', title: 'Premium Materials', desc: 'Only the finest stone is selected for each project, ensuring longevity and divine beauty.' },
  { icon: '🤝', title: 'Generational Trust', desc: 'Families and institutions return to us because our word is our bond — backed by generations of reputation.' },
  { icon: '🔬', title: 'Meticulous Precision', desc: 'Every measurement, every carving, every proportion is executed with mathematical precision rooted in Vaastu Shastra.' },
  { icon: '🌟', title: 'Divine Purpose', desc: 'We do not merely build structures — we create sacred spaces where the divine can dwell.' },
  { icon: '🏗️', title: 'End-to-End Service', desc: 'From concept and design to construction and consecration, we manage every phase of your temple project.' },
]

const milestones = [
  { year: 'Foundation', title: 'Legacy Begins', desc: 'N. Prabhu Sthabathiyar continues the ancient Sthapathi lineage, mastering temple construction arts.' },
  { year: 'Early Works', title: 'Regional Recognition', desc: 'Several South Indian-style temples completed in the Trichy and Srirangam belt, gaining widespread recognition.' },
  { year: 'Notable Achievement', title: 'HH 44th Jeeyar Patronage', desc: 'Received the distinguished patronage of HH 44th Jeeyar, marking a milestone in our legacy.' },
  { year: 'Landmark', title: 'Srirangam Agopila Math', desc: 'Constructed the world-unique Dasaavathara temple — a once-in-a-lifetime architectural achievement.' },
  { year: 'Expansion', title: 'North Indian Style Mastery', desc: 'Expanded expertise to Nagara-style temple construction, broadening our national reach.' },
  { year: 'Present', title: 'Continuing the Mission', desc: 'Active projects across South India, carving idols and building temples that will endure for centuries.' },
]

onMounted(() => {
  const obs = new IntersectionObserver((entries) => {
    entries.forEach(e => { if (e.isIntersecting) { e.target.classList.add('in-view'); obs.unobserve(e.target) } })
  }, { threshold: 0.1 })
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

/* STORY */
.story-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 4rem;
  align-items: center;
}
.story-text p { color: var(--text-muted); margin-bottom: 1rem; }
.tamil-name { font-size: 1.2rem; color: var(--text-muted); font-family: var(--font-sans); font-weight: 300; margin-bottom: 0.5rem; }
blockquote {
  border-left: 3px solid var(--gold);
  padding: 0.75rem 1rem;
  color: var(--gold-light);
  font-style: italic;
  background: var(--gold-muted);
  border-radius: 0 8px 8px 0;
  margin: 1rem 0;
  font-size: 0.95rem;
}
.story-images img { width: 100%; height: 460px; object-fit: cover; border-radius: var(--radius); box-shadow: 0 20px 60px rgba(0,0,0,0.5); }

/* VALUES */
.section-head { margin-bottom: 3rem; }
.values-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 1.5rem;
}
.value-card {
  background: var(--bg-card);
  border: 1px solid var(--border);
  border-radius: var(--radius);
  padding: 2rem;
  transition: var(--transition);
}
.value-card:hover { border-color: rgba(212,175,55,0.3); transform: translateY(-5px); }
.v-icon { font-size: 2rem; margin-bottom: 1rem; }
.value-card h3 { font-family: var(--font-sans); font-size: 1rem; font-weight: 600; color: #fff; margin-bottom: 0.75rem; }
.value-card p { color: var(--text-muted); font-size: 0.875rem; line-height: 1.6; }

/* TIMELINE */
.timeline { position: relative; }
.timeline::before {
  content: '';
  position: absolute;
  left: 0; top: 0; bottom: 0;
  width: 2px;
  background: linear-gradient(to bottom, var(--gold), transparent);
  margin-left: 8px;
}
.timeline-item {
  display: flex;
  gap: 2rem;
  margin-bottom: 3rem;
  position: relative;
}
.t-dot {
  width: 18px; height: 18px;
  background: var(--gold);
  border-radius: 50%;
  flex-shrink: 0;
  margin-top: 4px;
  box-shadow: 0 0 0 4px var(--gold-muted);
}
.t-year {
  display: inline-block;
  font-size: 0.75rem;
  font-weight: 600;
  letter-spacing: 2px;
  text-transform: uppercase;
  color: var(--gold);
  margin-bottom: 0.5rem;
}
.t-content h4 { font-family: var(--font-sans); font-size: 1rem; font-weight: 600; color: #fff; margin-bottom: 0.5rem; }
.t-content p { color: var(--text-muted); font-size: 0.9rem; }

/* FEATURED */
.featured-inner {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 4rem;
  align-items: center;
}
.featured-img img { width: 100%; height: 440px; object-fit: cover; border-radius: var(--radius); box-shadow: 0 20px 60px rgba(0,0,0,0.5); }
.featured-text p { color: var(--text-muted); margin-bottom: 1rem; }
.featured-text .btn { margin-top: 0.5rem; }

@media (max-width: 768px) {
  .story-grid, .featured-inner { grid-template-columns: 1fr; }
  .values-grid { grid-template-columns: repeat(2, 1fr); }
}
@media (max-width: 480px) { .values-grid { grid-template-columns: 1fr; } }
</style>
