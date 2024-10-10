import { defineConfig, passthroughImageService } from 'astro/config'

import alpinejs from '@astrojs/alpinejs'
import solidJs from '@astrojs/solid-js'
import tailwind from '@astrojs/tailwind'

export default defineConfig({
  integrations: [
    tailwind(),
    alpinejs({
      entrypoint: 'alpine.config.ts',
    }),
    solidJs(),
  ],
  image: {
    service: passthroughImageService(),
  },
})
