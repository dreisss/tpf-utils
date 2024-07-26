import { Elysia, t } from 'elysia'

import { USERNAME_REGEX } from '@/lib/utils'
import { db } from '@/lib/drizzle'
import { users } from '@db/schemas/auth'

const createUserBodySchema = t.Object({
  username: t.String({ pattern: USERNAME_REGEX }),
  password: t.String({ minLength: 8, maxLength: 16 }),
})

export const createUser = new Elysia().post(
  '',
  async ({ body, error, set }) => {
    const { username, password } = body

    const userWithUsername = await db.query.users.findFirst({
      where: (user, { eq }) => eq(user.username, username),
    })

    if (userWithUsername) return error(409, 'An user with this username already exists!')

    const passwordHash = await Bun.password.hash(password)

    const user = (
      await db
        .insert(users)
        .values({
          username,
          passwordHash,
        })
        .returning({ id: users.id })
    )[0]

    set.status = 202
    return { user }
  },
  { body: createUserBodySchema },
)
