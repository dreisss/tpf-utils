import { Elysia } from 'elysia'

import { createUser } from './create'
import { getManyUsers } from './get-many'

export const usersRoutes = new Elysia().group('/users', (app) => app.use(createUser).use(getManyUsers))
