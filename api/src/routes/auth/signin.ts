import { Elysia, t } from 'elysia'

import { db } from '@/lib/drizzle'
import { lucia } from '@/lib/lucia'
import { USERNAME_REGEX } from '@/lib/utils'

const createUserBodySchema = t.Object({
  username: t.String({ pattern: String(USERNAME_REGEX) }),
  password: t.String({ minLength: 8, maxLength: 16 }),
})

export const signIn = new Elysia().post(
  '/signin',
  async ({ body, set, error }) => {
    const { username, password } = body

    const user = await db.query.users.findFirst({
      where: (user, { eq }) => eq(user.username, username),
      columns: { id: true, passwordHash: true },
    })

    if (!user) return error(400, 'Invalid username or password!')

    const isCorrectPassword = await Bun.password.verify(password, user.passwordHash)

    if (!isCorrectPassword) return error(400, 'Invalid username or password!')

    const session = await lucia.createSession(user.id, {})
    const sessionCookie = lucia.createSessionCookie(session.id)

    set.headers = {
      location: '/',
      'set-cookie': sessionCookie.serialize(),
    }

    return { user }
  },
  { body: createUserBodySchema },
)
