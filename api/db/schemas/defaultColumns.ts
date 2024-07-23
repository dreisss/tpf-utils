import { timestamp, uuid, varchar } from 'drizzle-orm/pg-core'

import { employees } from './employees'

export const idCreateUpdateColumns = {
  id: uuid('id').primaryKey().defaultRandom(),
  createdAt: timestamp('created_at').defaultNow().notNull(),
  updatedAt: timestamp('updated_at').defaultNow().notNull(),
  createdBy: uuid('created_by_id')
    .notNull()
    .references(() => employees.id),
  updatedBy: uuid('updated_by_id')
    .notNull()
    .references(() => employees.id),
}

export const nameDescriptionColumns = {
  name: varchar('name', { length: 128 }).notNull(),
  description: varchar('description', { length: 256 }),
}
