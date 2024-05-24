import { FastifyRequest } from "fastify"

export const useVerifyCollaboratorBody = (request: FastifyRequest) => {
  const schema = ["name", "email", "phone"]
  const data = request.body

  const result = schema.map(child => {
    if (data[child] == undefined || data[child]?.length < 0) return false

    return true
  })

  const existsFalse = result.includes(false)

  return existsFalse
}
