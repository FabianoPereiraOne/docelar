import { FastifyInstance, FastifyReply, FastifyRequest } from "fastify"
import { useCompareHash } from "../../hooks/useCompareHash"
import { useGenerateToken } from "../../hooks/useGenerateToken"
import { fetchCollaboratorByEmail } from "../../services/prisma/collaborator/fetchByEmail"
import { statusCode } from "../../utils/statusCode"

export default async function Sign(server: FastifyInstance) {
  server.post("/sign", async (request: FastifyRequest, reply: FastifyReply) => {
    const password = request.headers["password"]
    const data: any = request.body
    const email = data?.collaborator?.email
    const existsPass = !!password
    const existsEmail = !!email

    if (!existsEmail || !existsPass || typeof password != "string") {
      return reply.status(statusCode.badRequest.status).send({
        error: statusCode.badRequest.error,
        description: "Insufficient collaborator data"
      })
    }

    try {
      const collaborator = await fetchCollaboratorByEmail(email)
      const existsCollaborator = !!collaborator

      if (!existsCollaborator) {
        return reply.status(statusCode.notFound.status).send({
          error: statusCode.notFound.error,
          description: "We were unable to locate the collaborator"
        })
      }

      const hash = collaborator.password
      const match = await useCompareHash(password, hash)

      if (!match) {
        return reply.status(statusCode.unAuthorized.status).send({
          error: statusCode.unAuthorized.error,
          description: "The password provided is invalid"
        })
      }

      const { id } = collaborator

      const authorization = await useGenerateToken(id, email)
      return reply.status(statusCode.success.status).send({
        authorization
      })
    } catch (error: any) {
      return reply.status(statusCode.serverError.status).send({
        error: statusCode.serverError.error,
        description:
          "Something unexpected happened during processing on the server"
      })
    }
  })
}
