import { describe, expect, it } from 'bun:test'
import { app } from '@/index'
import { treaty } from '@elysiajs/eden'

const api = treaty(app)

describe('Elysia', () => {
  it('Elysia test', async () => {
    expect(api).pass()
  })
})
