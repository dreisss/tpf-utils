import { pgTable } from 'drizzle-orm/pg-core'

import { idColumn, nameColumn, upsertAtColumns, upsertByIdColumns } from './commonColumns'

export const employees = pgTable('employees', {
  ...idColumn,
  ...upsertAtColumns,
  ...upsertByIdColumns,
  ...nameColumn,
})
