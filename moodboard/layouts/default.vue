<template>
  <div class="site-wrapper">
    <AppNavbar />
    <main>
      <slot />
    </main>
    <AppFooter />
    <AppWhatsApp />
  </div>
</template>

<style>
.site-wrapper {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
}
main { flex: 1; }
</style>
