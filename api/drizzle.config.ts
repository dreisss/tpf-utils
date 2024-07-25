import { defineConfig } from 'drizzle-kit'

export default defineConfig({
  dialect: 'postgresql',
  schema: './db/schemas',
  out: './db/migrations',
  dbCredentials: {
    url: process.env.DATABASE_URL as string,
  },
})
