import { integer, pgTable } from 'drizzle-orm/pg-core'

import { idCreateUpdateColumns, nameDescriptionColumns } from './defaultColumns'

export const stockItems = pgTable('stock_items', {
  ...idCreateUpdateColumns,
  ...nameDescriptionColumns,

  currentQuantity: integer('current_quantity').notNull(),
  alertLowQuantity: integer('alert_low_quantity').default(0).notNull(),
})
