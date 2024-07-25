import { DrizzlePostgreSQLAdapter } from '@lucia-auth/adapter-drizzle'
import { Lucia } from 'lucia'

import { sessions, users } from '@db/schemas/auth'
import { db } from './drizzle'

const adapter = new DrizzlePostgreSQLAdapter(db, sessions, users)

export const lucia = new Lucia(adapter, {
  sessionCookie: {
    attributes: { secure: process.env.NODE_ENV === 'production' },
  },
})

declare module 'lucia' {
  interface Register {
    Lucia: typeof lucia
  }
}
