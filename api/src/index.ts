import { cors } from '@elysiajs/cors'
import { swagger } from '@elysiajs/swagger'
import { Elysia } from 'elysia'

import { authRoutes } from '@/routes/auth'
import { usersRoutes } from '@/routes/users'

const corsPlugin = cors({
  origin: '*',
})

export const app = new Elysia()
  .use(swagger())
  .use(corsPlugin)
  .use(authRoutes)
  .use(usersRoutes)
  .listen(process.env.PORT as string)

export type App = typeof app

console.log(`🦊 Elysia is running at ${process.env.BASE_URL}`)
