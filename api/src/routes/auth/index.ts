import { Elysia } from 'elysia'

import { signIn } from './signin'

export const authRoutes = new Elysia().group('/auth', (app) => app.use(signIn))
