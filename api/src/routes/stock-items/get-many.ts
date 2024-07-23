import { Elysia } from 'elysia'

import { db } from '@/lib/drizzle'

export const getManyStockItems = new Elysia().get('/', async () => {
  const stockItems = await db.query.stockItems.findMany({
    columns: {
      id: true,
      name: true,
      description: true,
      currentQuantity: true,
    },
  })

  return { items: stockItems }
})
