<template>
  <div>
    <section class="page-hero">
      <div class="page-hero-bg">
        <img src="/gallery/img_014.jpeg" alt="Contact PMK" />
        <div class="page-hero-overlay" />
      </div>
      <div class="container page-hero-content">
        <span class="section-label">Get In Touch</span>
        <h1 class="section-title">Contact Us</h1>
        <p class="section-sub">Ready to build something sacred? Let's talk about your vision.</p>
      </div>
    </section>

    <section class="contact-section section-pad">
      <div class="container contact-wrapper">
        <!-- INFO -->
        <div class="contact-info reveal">
          <span class="section-label">Our Details</span>
          <h2 class="section-title">Let's Connect</h2>
          <div class="gold-line" />
          <p class="contact-desc">We'd love to hear about your temple project or idol requirements. Reach out via phone, email, or fill in the form and we'll get back to you promptly.</p>

          <div class="info-cards">
            <a href="https://wa.me/918804975555" target="_blank" class="info-card wa-card">
              <span class="ic-icon">💬</span>
              <div>
                <h4>WhatsApp</h4>
                <p>+91 88049 75555</p>
                <small>Fastest response</small>
              </div>
            </a>
            <a href="tel:+918804975555" class="info-card">
              <span class="ic-icon">📞</span>
              <div>
                <h4>Phone</h4>
                <p>+91 88049 75555<br>+91 86809 74446</p>
              </div>
            </a>
            <a href="mailto:prabu775@gmail.com" class="info-card">
              <span class="ic-icon">✉️</span>
              <div>
                <h4>Email</h4>
                <p>prabu775@gmail.com</p>
              </div>
            </a>
            <div class="info-card">
              <span class="ic-icon">📍</span>
              <div>
                <h4>Address</h4>
                <p>36, Vadakkuvasal, Kollidakkarai Road,<br>Srirangam, Trichy-6, Tamil Nadu.</p>
              </div>
            </div>
          </div>
        </div>

        <!-- FORM -->
        <div class="contact-form-wrap reveal reveal-delay-2">
          <form class="contact-form" @submit.prevent="handleSubmit">
            <h3>Send Us a Message</h3>
            <div class="form-row">
              <div class="form-group">
                <label for="name">Your Name</label>
                <input id="name" v-model="form.name" type="text" required placeholder="e.g. Ramesh Kumar" />
              </div>
              <div class="form-group">
                <label for="phone">Phone Number</label>
                <input id="phone" v-model="form.phone" type="tel" required placeholder="+91 XXXXX XXXXX" />
              </div>
            </div>
            <div class="form-group">
              <label for="email">Email Address</label>
              <input id="email" v-model="form.email" type="email" required placeholder="your@email.com" />
            </div>
            <div class="form-group">
              <label for="service">Service Required</label>
              <select id="service" v-model="form.service">
                <option value="">Select a service...</option>
                <option>South Indian Style Temple</option>
                <option>North Indian Style Temple</option>
                <option>Idol / Sculpture Creation</option>
                <option>Temple Renovation</option>
                <option>General Inquiry</option>
              </select>
            </div>
            <div class="form-group">
              <label for="message">Project Details</label>
              <textarea id="message" v-model="form.message" rows="5" required placeholder="Tell us about your project — location, type, scale, timeline..."></textarea>
            </div>
            <button type="submit" class="btn btn-primary submit-btn" :disabled="submitted">
              <span v-if="!submitted">Send Message →</span>
              <span v-else>✓ Message Sent!</span>
            </button>
          </form>
        </div>
      </div>
    </section>
  </div>
</template>

<script setup>
useHead({ title: 'Contact | P.M.K. Temple Architect' })

const submitted = ref(false)
const form = reactive({ name: '', phone: '', email: '', service: '', message: '' })

function handleSubmit () {
  // Simulate send
  submitted.value = true
  setTimeout(() => {
    submitted.value = false
    Object.keys(form).forEach(k => form[k] = '')
  }, 4000)
}

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

.contact-wrapper {
  display: grid;
  grid-template-columns: 1fr 1.3fr;
  gap: 4rem;
  align-items: start;
}
.contact-desc { color: var(--text-muted); margin: 1rem 0 2rem; }

.info-cards { display: flex; flex-direction: column; gap: 1rem; }
.info-card {
  display: flex;
  align-items: flex-start;
  gap: 1.25rem;
  background: var(--bg-card);
  border: 1px solid var(--border);
  border-radius: var(--radius);
  padding: 1.25rem;
  transition: var(--transition);
}
.info-card:hover { border-color: rgba(212,175,55,0.3); transform: translateX(5px); }
.wa-card { border-color: rgba(37,211,102,0.3); }
.wa-card:hover { border-color: rgba(37,211,102,0.6); background: rgba(37,211,102,0.05); }
.ic-icon { font-size: 1.5rem; flex-shrink: 0; margin-top: 2px; }
.info-card h4 { font-family: var(--font-sans); font-size: 0.75rem; font-weight: 600; letter-spacing: 1.5px; text-transform: uppercase; color: var(--gold); margin-bottom: 0.35rem; }
.info-card p { color: var(--text); font-size: 0.9rem; line-height: 1.5; }
.info-card small { color: #25d366; font-size: 0.75rem; font-weight: 500; }

/* FORM */
.contact-form-wrap {
  background: var(--bg-card);
  border: 1px solid var(--border);
  border-radius: var(--radius);
  padding: 2.5rem;
}
.contact-form h3 { font-family: var(--font-sans); font-size: 1.2rem; font-weight: 600; color: #fff; margin-bottom: 1.75rem; }
.form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 1.25rem; }
.form-group { margin-bottom: 1.25rem; }
.form-group label { display: block; font-size: 0.8rem; font-weight: 500; letter-spacing: 0.5px; color: var(--text-muted); margin-bottom: 0.5rem; text-transform: uppercase; }
.form-group input, .form-group select, .form-group textarea {
  width: 100%;
  padding: 0.85rem 1rem;
  background: rgba(255,255,255,0.04);
  border: 1px solid var(--border);
  border-radius: 8px;
  color: var(--text);
  font-family: var(--font-sans);
  font-size: 0.95rem;
  transition: var(--transition);
  outline: none;
  -webkit-appearance: none;
}
.form-group input:focus, .form-group select:focus, .form-group textarea:focus {
  border-color: var(--gold);
  background: var(--gold-muted);
}
.form-group select option { background: var(--bg-card); color: var(--text); }
.submit-btn { width: 100%; justify-content: center; margin-top: 0.5rem; }
.submit-btn:disabled { background: #22c55e; cursor: default; transform: none; box-shadow: none; }

@media (max-width: 768px) {
  .contact-wrapper { grid-template-columns: 1fr; }
  .form-row { grid-template-columns: 1fr; }
}
</style>
