<template>
  <nav class="navbar" :class="{ scrolled: isScrolled }">
    <div class="nav-inner container">

      <!-- Logo -->
      <NuxtLink to="/" class="nav-logo" @click="closeMenu">
        <span class="logo-mark">PMK</span>
        <span class="logo-full">P.M.K. Temple Architect</span>
      </NuxtLink>

      <!-- Desktop links -->
      <ul class="nav-links">
        <li><NuxtLink to="/" exact-active-class="active">Home</NuxtLink></li>
        <li><NuxtLink to="/about" active-class="active">About</NuxtLink></li>
        <li><NuxtLink to="/services" active-class="active">Services</NuxtLink></li>
        <li><NuxtLink to="/gallery" active-class="active">Gallery</NuxtLink></li>
        <li><NuxtLink to="/contact" class="btn btn-primary nav-cta">Contact Us</NuxtLink></li>
      </ul>

      <!-- Hamburger (mobile only) -->
      <button
        class="hamburger"
        :class="{ active: menuOpen }"
        aria-label="Toggle navigation menu"
        :aria-expanded="menuOpen"
        @click="toggleMenu"
      >
        <span /><span /><span />
      </button>
    </div>

    <!-- Mobile drawer + backdrop — rendered inside nav to inherit z-index context -->
    <Transition name="backdrop">
      <div v-if="menuOpen" class="mobile-backdrop" @click="closeMenu" />
    </Transition>

    <Transition name="drawer">
      <div v-if="menuOpen" class="mobile-drawer" role="dialog" aria-label="Navigation menu">
        <!-- Drawer header -->
        <div class="drawer-header">
          <span class="logo-mark">PMK</span>
          <button class="drawer-close" aria-label="Close menu" @click="closeMenu">✕</button>
        </div>

        <nav class="drawer-links">
          <NuxtLink to="/" exact-active-class="active" @click="closeMenu">
            <span class="link-icon">🏠</span> Home
          </NuxtLink>
          <NuxtLink to="/about" active-class="active" @click="closeMenu">
            <span class="link-icon">👤</span> About
          </NuxtLink>
          <NuxtLink to="/services" active-class="active" @click="closeMenu">
            <span class="link-icon">🏛️</span> Services
          </NuxtLink>
          <NuxtLink to="/gallery" active-class="active" @click="closeMenu">
            <span class="link-icon">🖼️</span> Gallery
          </NuxtLink>
        </nav>

        <div class="drawer-footer">
          <NuxtLink to="/contact" class="btn btn-primary drawer-cta" @click="closeMenu">
            Contact Us →
          </NuxtLink>
          <div class="drawer-contact">
            <a href="tel:+918804975555">📞 +91 88049 75555</a>
            <a href="https://wa.me/918804975555" target="_blank">💬 WhatsApp Us</a>
          </div>
        </div>
      </div>
    </Transition>
  </nav>
</template>

<script setup>
const isScrolled = ref(false)
const menuOpen = ref(false)

function toggleMenu () { menuOpen.value = !menuOpen.value }
function closeMenu () { menuOpen.value = false }

// Lock body scroll when menu is open
watch(menuOpen, (open) => {
  if (import.meta.client) {
    document.body.style.overflow = open ? 'hidden' : ''
  }
})

// Close on Escape key
onMounted(() => {
  window.addEventListener('scroll', () => {
    isScrolled.value = window.scrollY > 40
  })
  window.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') closeMenu()
  })
})

onUnmounted(() => {
  if (import.meta.client) document.body.style.overflow = ''
})
</script>

<style scoped>
/* ── Navbar shell ─────────────────────────────────────────── */
.navbar {
  position: fixed;
  top: 0;
  width: 100%;
  z-index: 1000;
  padding: 1.25rem 0;
  background: var(--bg-nav);
  backdrop-filter: blur(14px);
  -webkit-backdrop-filter: blur(14px);
  border-bottom: 1px solid transparent;
  transition: padding 0.3s ease, border-color 0.3s ease, box-shadow 0.3s ease;
}
.navbar.scrolled {
  padding: 0.8rem 0;
  border-color: var(--border);
  box-shadow: 0 4px 30px rgba(0,0,0,0.5);
}

.nav-inner {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 1rem;
}

/* ── Logo ──────────────────────────────────────────────────── */
.nav-logo {
  display: flex;
  align-items: center;
  gap: 0.6rem;
  flex-shrink: 0;
  z-index: 1002;
  position: relative;
}
.logo-mark {
  font-family: var(--font-serif);
  font-size: 1.3rem;
  font-weight: 700;
  color: var(--gold);
  background: var(--gold-muted);
  border: 1px solid rgba(212,175,55,0.3);
  padding: 0.15rem 0.55rem;
  border-radius: 6px;
}
.logo-full {
  font-family: var(--font-serif);
  font-size: 0.95rem;
  font-weight: 600;
  color: var(--text);
  letter-spacing: 0.5px;
}

/* ── Desktop nav links ────────────────────────────────────── */
.nav-links {
  display: flex;
  align-items: center;
  gap: 2rem;
  list-style: none;
}
.nav-links a {
  font-size: 0.95rem;
  font-weight: 500;
  color: var(--text-muted);
  position: relative;
  transition: color 0.25s ease;
}
.nav-links a::after {
  content: '';
  position: absolute;
  bottom: -4px; left: 0;
  width: 0; height: 2px;
  background: var(--gold);
  border-radius: 2px;
  transition: width 0.25s ease;
}
.nav-links a:hover,
.nav-links a.active { color: #fff; }
.nav-links a:hover::after,
.nav-links a.active::after { width: 100%; }
.nav-links .nav-cta { color: #0d0f14 !important; }
.nav-links .nav-cta::after { display: none; }

/* ── Hamburger ─────────────────────────────────────────────── */
.hamburger {
  display: none;
  flex-direction: column;
  justify-content: center;
  gap: 5px;
  background: none;
  border: none;
  cursor: pointer;
  padding: 8px;
  border-radius: 8px;
  z-index: 1002;
  position: relative;
  transition: background 0.2s ease;
  -webkit-tap-highlight-color: transparent;
  min-width: 44px;
  min-height: 44px;
}
.hamburger:active { background: var(--gold-muted); }
.hamburger span {
  display: block;
  width: 24px; height: 2px;
  background: var(--text);
  border-radius: 2px;
  transition: transform 0.3s ease, opacity 0.3s ease;
  transform-origin: center;
}
.hamburger.active span:nth-child(1) { transform: translateY(7px) rotate(45deg); }
.hamburger.active span:nth-child(2) { opacity: 0; transform: scaleX(0); }
.hamburger.active span:nth-child(3) { transform: translateY(-7px) rotate(-45deg); }

/* ── Mobile backdrop ──────────────────────────────────────── */
.mobile-backdrop {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.6);
  backdrop-filter: blur(2px);
  z-index: 1010;
  touch-action: none;
}

/* ── Mobile drawer ────────────────────────────────────────── */
.mobile-drawer {
  position: fixed;
  top: 0;
  right: 0;
  width: min(85vw, 320px);
  height: 100dvh; /* dynamic viewport height — handles mobile chrome bar */
  height: 100vh;  /* fallback */
  background: #0d0f14;
  border-left: 1px solid var(--border);
  z-index: 1020;
  display: flex;
  flex-direction: column;
  overflow-y: auto;
  -webkit-overflow-scrolling: touch;
  box-shadow: -20px 0 60px rgba(0,0,0,0.6);
}

.drawer-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 1.25rem 1.5rem;
  border-bottom: 1px solid var(--border);
  flex-shrink: 0;
}
.drawer-close {
  background: rgba(255,255,255,0.06);
  border: 1px solid var(--border);
  color: var(--text-muted);
  font-size: 1rem;
  width: 40px; height: 40px;
  border-radius: 8px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.2s ease;
  -webkit-tap-highlight-color: transparent;
}
.drawer-close:active { background: var(--gold-muted); color: var(--gold); }

.drawer-links {
  display: flex;
  flex-direction: column;
  padding: 1rem 0;
  flex: 1;
}
.drawer-links a {
  display: flex;
  align-items: center;
  gap: 1rem;
  padding: 1rem 1.75rem;
  font-size: 1.1rem;
  font-weight: 500;
  color: var(--text-muted);
  border-left: 3px solid transparent;
  transition: all 0.2s ease;
  -webkit-tap-highlight-color: transparent;
}
.drawer-links a:active,
.drawer-links a.active {
  color: var(--gold);
  border-left-color: var(--gold);
  background: var(--gold-muted);
}
.link-icon { font-size: 1.1rem; width: 24px; text-align: center; }

.drawer-footer {
  padding: 1.5rem;
  border-top: 1px solid var(--border);
  flex-shrink: 0;
}
.drawer-cta {
  width: 100%;
  justify-content: center;
  font-size: 1rem;
  padding: 0.9rem;
  margin-bottom: 1.25rem;
}
.drawer-contact {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}
.drawer-contact a {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  color: var(--text-muted);
  font-size: 0.875rem;
  padding: 0.5rem;
  border-radius: 8px;
  transition: color 0.2s;
  -webkit-tap-highlight-color: transparent;
}
.drawer-contact a:active { color: var(--gold); }

/* ── Transitions ──────────────────────────────────────────── */
.backdrop-enter-active,
.backdrop-leave-active { transition: opacity 0.3s ease; }
.backdrop-enter-from,
.backdrop-leave-to { opacity: 0; }

.drawer-enter-active,
.drawer-leave-active { transition: transform 0.35s cubic-bezier(0.4, 0, 0.2, 1); }
.drawer-enter-from,
.drawer-leave-to { transform: translateX(100%); }

/* ── Responsive breakpoint ────────────────────────────────── */
@media (max-width: 860px) {
  .hamburger { display: flex; }
  .logo-full { display: none; }
  .nav-links { display: none; }
}
</style>
