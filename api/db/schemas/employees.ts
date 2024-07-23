import { type AnyPgColumn, pgTable, uuid, timestamp } from 'drizzle-orm/pg-core'

export const employees = pgTable('employees', {
  id: uuid('id').primaryKey().defaultRandom(),
  createdAt: timestamp('created_at').defaultNow().notNull(),
  updatedAt: timestamp('updated_at').defaultNow().notNull(),
  createdBy: uuid('created_by_id')
    .notNull()
    .references((): AnyPgColumn => employees.id),
  updatedBy: uuid('updated_by_id')
    .notNull()
    .references((): AnyPgColumn => employees.id),
})
