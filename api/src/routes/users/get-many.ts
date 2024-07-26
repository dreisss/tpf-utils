import { Elysia } from 'elysia'

import { db } from '@/lib/drizzle'

export const getManyUsers = new Elysia().get('', async () => {
  const users = await db.query.users.findMany({
    columns: {
      id: true,
      username: true,
      employeeId: true,
    },
  })

  return { users }
})
