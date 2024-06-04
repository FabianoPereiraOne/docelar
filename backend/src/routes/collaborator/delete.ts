import { FastifyInstance, FastifyReply, FastifyRequest } from "fastify"
import { OperationMiddleware } from "../../middlewares/operation"
import { deleteCollaborator } from "../../services/prisma/collaborator/delete"
import { fetchCollaborator } from "../../services/prisma/collaborator/fetch"
import { statusCode } from "../../utils/statusCode"

export default async function DeleteCollaborator(server: FastifyInstance) {
  server.delete(
    "/collaborator",
    { preHandler: OperationMiddleware },
    async (request: FastifyRequest, reply: FastifyReply) => {
      const { id }: any = request.query
      const hasID = !!id

      if (!hasID)
        return reply.status(statusCode.badRequest.status).send({
          error: statusCode.badRequest.error,
          description: "Employee ID was not provided"
        })

      const collaborator = await fetchCollaborator(id)
      const hasCollaborator = !!collaborator

      if (!hasCollaborator)
        return reply.status(statusCode.notFound.status).send({
          error: statusCode.notFound.error,
          description: "We were unable to locate the employee"
        })

      // Implements this code future
      // const hasHomeLinked = collaborator.Home.length > 0

      // if (hasHomeLinked) {
      //   return reply.status(statusCode.unAuthorized.status).send({
      //     error: statusCode.unAuthorized.error,
      //     description: "Unable to delete collaborator with linked homes"
      //   })
      // }

      try {
        await deleteCollaborator(id).then(data => {
          return reply.status(statusCode.success.status).send({
            data
          })
        })
      } catch (error) {
        return reply.status(statusCode.serverError.status).send({
          error: statusCode.serverError.error,
          description:
            "Something unexpected happened during processing on the server"
        })
      }
    }
  )
}
