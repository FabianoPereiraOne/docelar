import { FastifyInstance, FastifyReply, FastifyRequest } from "fastify"
import { OperationMiddleware } from "../../middlewares/operation"
import { Schemas } from "../../schemas"
import { fetchHome } from "../../services/prisma/homes/fetch"
import { updateHome } from "../../services/prisma/homes/update"
import { CustomTypePatch } from "../../types/request/homes"
import { statusCode } from "../../utils/statusCode"

export default async function PatchHomes(server: FastifyInstance) {
  server.patch<CustomTypePatch>(
    "/homes",
    {
      preHandler: OperationMiddleware,
      schema: Schemas.homes.patch
    },
    async (request: FastifyRequest<CustomTypePatch>, reply: FastifyReply) => {
      const { id } = request.query
      const { cep, address, city, number, state, status, district } =
        request.body

      const hasHome = !!(await fetchHome(id))
      if (!hasHome) {
        return reply.status(statusCode.notFound.status).send({
          error: statusCode.notFound.error,
          description: "We were unable to locate the home"
        })
      }

      try {
        const home = {
          id,
          cep,
          address,
          city,
          district,
          number,
          state,
          status
        }
        const data = await updateHome(home)
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
