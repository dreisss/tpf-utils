import daisyui from 'daisyui'

/** @type {import('tailwindcss').Config} */
export default {
  content: ['./src/**/*.{astro,html}'],
  theme: {
    extend: {},
  },
  plugins: [daisyui],

  daisyui: {
    logs: false,
    themes: ['night'],
  },
}
