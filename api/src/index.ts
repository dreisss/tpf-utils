import { Elysia } from 'elysia'
import { swagger } from '@elysiajs/swagger'
import { cors } from '@elysiajs/cors'

const corsPlugin = cors({
  origin: '*',
})

export const app = new Elysia()
  .use(swagger())
  .use(corsPlugin)
  .listen(process.env.PORT as string)

export type App = typeof app

console.log(`🦊 Elysia is running at ${process.env.BASE_URL}`)
