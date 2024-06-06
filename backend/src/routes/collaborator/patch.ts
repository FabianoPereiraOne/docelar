import { FastifyInstance, FastifyReply, FastifyRequest } from "fastify"
import { useGenerateHash } from "../../hooks/useGenerateHash"
import { OperationMiddleware } from "../../middlewares/operation"
import { fetchCollaborator } from "../../services/prisma/collaborator/fetch"
import { updateCollaborator } from "../../services/prisma/collaborator/update"
import { CollaboratorParamsUpdate } from "../../types/collaborator"
import { statusCode } from "../../utils/statusCode"

export default async function PatchCollaborator(server: FastifyInstance) {
  server.patch(
    "/collaborator",
    { preHandler: OperationMiddleware },
    async (request: FastifyRequest, reply: FastifyReply) => {
      const { id }: any = request.query
      const { collaborator }: any = request.body
      const password = request.headers["password"]
      const hasID = !!id

      const existsCollaborator = !!collaborator

      if (!hasID)
        return reply.status(statusCode.badRequest.status).send({
          error: statusCode.badRequest.error,
          description: "Collaborator ID was not provided"
        })

      if (!existsCollaborator) {
        return reply.status(statusCode.badRequest.status).send({
          error: statusCode.badRequest.error,
          description: "Data collaborator not provided"
        })
      }

      const { name, phone, type, statusAccount } = collaborator

      const hasCollaborator = !!(await fetchCollaborator(id))
      if (!hasCollaborator)
        return reply.status(statusCode.notFound.status).send({
          error: statusCode.notFound.error,
          description: "We were unable to locate the collaborator"
        })

      try {
        const collaborator: CollaboratorParamsUpdate = {
          id,
          name,
          phone,
          type,
          statusAccount,
          password:
            password != undefined
              ? await useGenerateHash(password as string)
              : undefined
        }

        await updateCollaborator(collaborator).then(data => {
          return reply.status(statusCode.success.status).send({
            data
          })
        })
      } catch (error: any) {
        console.log(error)
        return reply.status(statusCode.serverError.status).send({
          error: statusCode.serverError.error,
          description:
            "Something unexpected happened during processing on the server"
        })
      }
    }
  )
}
