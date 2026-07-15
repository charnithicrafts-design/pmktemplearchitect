// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  devtools: { enabled: true },

  // Static site generation — outputs to .output/public for FTP hosting
  nitro: { preset: 'static' },
  ssr: true,
  app: {
    head: {
      title: 'P.M.K. Temple Architect | Divine Craftsmanship in Stone',
      meta: [
        { charset: 'utf-8' },
        { name: 'viewport', content: 'width=device-width, initial-scale=1' },
        { name: 'description', content: 'P.M.K. Temple Architect – Master stone carpenters and temple contractors for South & North Indian temples and sacred idol creations. Sthapathi for generations.' },
        { name: 'theme-color', content: '#0f1115' }
      ],
      link: [
        { rel: 'preconnect', href: 'https://fonts.googleapis.com' },
        { rel: 'preconnect', href: 'https://fonts.gstatic.com', crossorigin: '' },
        { rel: 'stylesheet', href: 'https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&family=Playfair+Display:ital,wght@0,400;0,600;0,700;1,400&display=swap' }
      ]
    }
  },
  css: ['~/assets/css/main.css'],
  compatibilityDate: '2024-04-03'
})
