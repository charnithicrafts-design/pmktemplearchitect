<template>
  <footer class="footer">
    <div class="footer-top container">
      <div class="footer-brand">
        <span class="logo-mark">PMK</span>
        <h3>P.M.K. Temple Architect</h3>
        <p>Master stone carpenters crafting sacred temples and divine idols, guided by ancient Agama wisdom — for generations.</p>
        <p class="footer-motto">"Agama Vithipadi Seithu Tharapadam"</p>
      </div>
      <div class="footer-links">
        <h4>Quick Links</h4>
        <ul>
          <li><NuxtLink to="/">Home</NuxtLink></li>
          <li><NuxtLink to="/about">About</NuxtLink></li>
          <li><NuxtLink to="/services">Services</NuxtLink></li>
          <li><NuxtLink to="/gallery">Gallery</NuxtLink></li>
          <li><NuxtLink to="/contact">Contact</NuxtLink></li>
        </ul>
      </div>
      <div class="footer-contact">
        <h4>Contact</h4>
        <ul>
          <li>
            <span class="icon">📍</span>
            36, Vadakkuvasal, Kollidakkarai Road,<br>Srirangam, Trichy-6.
          </li>
          <li>
            <span class="icon">📞</span>
            <a href="tel:+918804975555">+91 88049 75555</a><br>
            <a href="tel:+918680974446">+91 86809 74446</a>
          </li>
          <li>
            <span class="icon">✉️</span>
            <a href="mailto:prabu775@gmail.com">prabu775@gmail.com</a>
          </li>
        </ul>
      </div>
    </div>
    <div class="footer-bottom">
      <p>&copy; {{ new Date().getFullYear() }} P.M.K. Temple Architect. All rights reserved.</p>
      <p class="footer-sub">HH 44th Jeeyar's — Generations of Sthapathi Excellence</p>
    </div>
  </footer>
</template>

<style scoped>
.footer {
  background: #090b0f;
  border-top: 1px solid var(--border);
}
.footer-top {
  display: grid;
  grid-template-columns: 2fr 1fr 1.5fr;
  gap: 3rem;
  padding: 4rem 1.5rem;
}
.footer-brand .logo-mark {
  display: inline-block;
  font-family: var(--font-serif);
  font-size: 1.2rem;
  font-weight: 700;
  color: var(--gold);
  background: var(--gold-muted);
  border: 1px solid rgba(212,175,55,0.3);
  padding: 0.1rem 0.5rem;
  border-radius: 6px;
  margin-bottom: 0.75rem;
}
.footer-brand h3 {
  font-size: 1.2rem;
  color: #fff;
  margin-bottom: 0.75rem;
  font-family: var(--font-sans);
  font-weight: 600;
}
.footer-brand p { color: var(--text-muted); font-size: 0.9rem; margin-bottom: 0.5rem; }
.footer-motto { color: var(--gold) !important; font-style: italic; }
.footer-links h4, .footer-contact h4 {
  font-family: var(--font-sans);
  font-size: 0.8rem;
  font-weight: 600;
  letter-spacing: 2px;
  text-transform: uppercase;
  color: var(--gold);
  margin-bottom: 1.25rem;
}
.footer-links ul, .footer-contact ul { display: flex; flex-direction: column; gap: 0.75rem; }
.footer-links a { color: var(--text-muted); transition: var(--transition); font-size: 0.95rem; }
.footer-links a:hover { color: var(--gold); padding-left: 5px; }
.footer-contact li {
  display: flex;
  align-items: flex-start;
  gap: 0.75rem;
  color: var(--text-muted);
  font-size: 0.9rem;
  line-height: 1.6;
}
.footer-contact .icon { flex-shrink: 0; font-size: 1rem; margin-top: 2px; }
.footer-contact a { color: var(--text-muted); transition: var(--transition); }
.footer-contact a:hover { color: var(--gold); }
.footer-bottom {
  border-top: 1px solid var(--border);
  padding: 1.25rem 1.5rem;
  text-align: center;
}
.footer-bottom p { color: var(--text-muted); font-size: 0.85rem; }
.footer-sub { color: var(--gold) !important; font-family: var(--font-serif); font-style: italic; margin-top: 0.25rem; }

@media (max-width: 768px) {
  .footer-top { grid-template-columns: 1fr; gap: 2rem; }
}
</style>
