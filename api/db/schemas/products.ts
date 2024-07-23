import { relations } from 'drizzle-orm'
import { pgTable } from 'drizzle-orm/pg-core'

import { idCreateUpdateColumns, nameDescriptionColumns } from './defaultColumns'
import { stockItems } from './stockItems'

export const products = pgTable('products', {
  ...idCreateUpdateColumns,
  ...nameDescriptionColumns,
})

export const productsRelations = relations(products, ({ many }) => ({
  stockItems: many(stockItems),
}))
