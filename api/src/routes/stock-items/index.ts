import { Elysia } from 'elysia'

import { getManyStockItems } from './get-many'

export const stockItemsRoutes = new Elysia().group('stock_items', (app) => app.use(getManyStockItems))
