import { Elysia } from 'elysia'

export const app = new Elysia().get('/', () => 'Hello Elysia').listen(process.env.PORT as string)

console.log(`🦊 Elysia is running at ${process.env.BASE_URL}`)
