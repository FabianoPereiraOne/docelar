import { FastifyInstance, FastifyReply, FastifyRequest } from "fastify"
import { operationMiddleware } from "../../middlewares/operation"
import { deleteCollaborator } from "../../services/prisma/collaborator/delete"
import { fetchCollaborator } from "../../services/prisma/collaborator/fetch"
import { statusCode } from "../../utils/statusCode"

export default async function DeleteCollaborator(server: FastifyInstance) {
  server.delete(
    "/collaborator",
    { preHandler: operationMiddleware },
    async (request: FastifyRequest, reply: FastifyReply) => {
      const { id }: any = request.query
      const hasID = !!id

      if (!hasID)
        return reply.status(statusCode.badRequest.status).send({
          statusCode: statusCode.badRequest.status,
          error: statusCode.badRequest.error,
          message: "Employee ID was not provided"
        })

      const collaborator = await fetchCollaborator(id)
      const hasCollaborator = !!collaborator

      if (!hasCollaborator)
        return reply.status(statusCode.notFound.status).send({
          statusCode: statusCode.notFound.status,
          error: statusCode.notFound.error,
          message: "We were unable to locate the employee"
        })

      const hasHomeLinked = collaborator.Home.length > 0

      if (hasHomeLinked) {
        return reply.status(statusCode.unAuthorized.status).send({
          statusCode: statusCode.unAuthorized.status,
          error: statusCode.unAuthorized.error,
          message: "Unable to delete collaborator with linked homes"
        })
      }

      try {
        await deleteCollaborator(id).then(data => {
          return reply.status(statusCode.success.status).send({
            statusCode: statusCode.success.status,
            success: statusCode.success.success,
            message: "Collaborator successfully deleted",
            data
          })
        })
      } catch (error) {
        return reply.send(error)
      }
    }
  )
}
