import { cors } from '@elysiajs/cors'
import { swagger } from '@elysiajs/swagger'
import { Elysia } from 'elysia'

const corsPlugin = cors({
  origin: '*',
})

export const app = new Elysia()
  .use(swagger())
  .use(corsPlugin)
  .listen(process.env.PORT as string)

export type App = typeof app

console.log(`🦊 Elysia is running at ${process.env.BASE_URL}`)
