import { timestamp, uuid, varchar } from 'drizzle-orm/pg-core'
import { users } from './auth'

export const idColumn = {
  id: uuid('id').primaryKey().defaultRandom(),
}

export const upsertAtColumns = {
  createdAt: timestamp('created_at').notNull().defaultNow(),
  updatedAt: timestamp('updated_at').notNull().defaultNow(),
}

export const upsertByIdColumns = {
  createdById: uuid('created_by_id')
    .notNull()
    .references(() => users.id),
  updatedById: uuid('updated_by_id')
    .notNull()
    .references(() => users.id),
}

export const nameColumn = {
  name: varchar('name').notNull(),
}

export const descriptionColumn = {
  name: varchar('description'),
}
