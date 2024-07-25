import { describe, expect, it } from 'bun:test'
import { treaty } from '@elysiajs/eden'

import { app } from '@/index'

const api = treaty(app)

describe('General Tests', () => {
  it('Elysia', async () => {
    expect(api).pass()
  })
})
