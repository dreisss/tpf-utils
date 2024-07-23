import { Elysia } from 'elysia'

import { stockItemsRoutes } from './routes/stock-items'

export const app = new Elysia().use(stockItemsRoutes).listen(process.env.PORT as string)

console.log(`🦊 Elysia is running at ${process.env.BASE_URL}`)
