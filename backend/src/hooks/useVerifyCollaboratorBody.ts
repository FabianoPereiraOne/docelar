import { FastifyRequest } from "fastify"

export const useVerifyCollaboratorBody = (request: FastifyRequest) => {
  const schema = ["name", "email", "phone"]
  const { collaborator }: any = request.body

  const result = schema.map(child => {
    if (collaborator[child] == undefined || collaborator[child]?.length < 0)
      return false

    return true
  })

  const existsFalse = result.includes(false)

  return existsFalse
}
