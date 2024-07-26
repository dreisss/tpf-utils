import { describe, expect, it } from 'bun:test'
import { treaty } from '@elysiajs/eden'

import { app } from '@/index'

const api = treaty(app)

describe('User Tests', () => {
  it('username must match defined format', async () => {
    expect(
      (
        await api.users.index.post({
          username: 'nomesobrenome',
          password: '12345678',
        })
      ).status,
    ).toBe(422)

    expect(
      (
        await api.users.index.post({
          username: 'nome sobrenome',
          password: '12345678',
        })
      ).status,
    ).toBe(422)

    expect(
      (
        await api.users.index.post({
          username: 'Nome sobrenome',
          password: '12345678',
        })
      ).status,
    ).toBe(422)

    expect(
      (
        await api.users.index.post({
          username: 'nome Sobrenome',
          password: '12345678',
        })
      ).status,
    ).toBe(422)
  })
})
