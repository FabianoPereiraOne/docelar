import { FastifyInstance, FastifyReply, FastifyRequest } from "fastify"
import { OperationMiddleware } from "../../middlewares/operation"
import { Schemas } from "../../schemas"
import { deleteHome } from "../../services/prisma/homes/delete"
import { fetchHome } from "../../services/prisma/homes/fetch"
import { CustomTypeDelete } from "../../types/request/general"
import { statusCode } from "../../utils/statusCode"

export default async function DeleteHomes(server: FastifyInstance) {
  server.delete<CustomTypeDelete>(
    "/homes",
    {
      preHandler: OperationMiddleware,
      schema: Schemas.general.delete
    },
    async (request: FastifyRequest<CustomTypeDelete>, reply: FastifyReply) => {
      const { id } = request.query

      const hasHome = !!(await fetchHome(id))
      if (!hasHome) {
        return reply.status(statusCode.notFound.status).send({
          error: statusCode.notFound.error,
          description: "We were unable to locate the home"
        })
      }

      try {
        const data = await deleteHome(id)
        return reply.status(statusCode.success.status).send({
          data
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
