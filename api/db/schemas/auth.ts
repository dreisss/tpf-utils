import { type AnyPgColumn, pgTable, timestamp, uuid, varchar } from 'drizzle-orm/pg-core'

import { idColumn, upsertAtColumns } from './commonColumns'
import { employees } from './employees'

export const users = pgTable('users', {
  ...idColumn,
  ...upsertAtColumns,
  employeeId: uuid('employee_id').references((): AnyPgColumn => employees.id),
  username: varchar('username').notNull(),
  passwordHash: varchar('password_hash', { length: 256 }).notNull(),
})

export const sessions = pgTable('sessions', {
  id: uuid('id').primaryKey(),
  userId: uuid('user_id')
    .notNull()
    .references(() => users.id),
  expiresAt: timestamp('expires_at').notNull(),
})
