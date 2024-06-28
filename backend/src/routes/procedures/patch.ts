import { FastifyInstance, FastifyReply, FastifyRequest } from "fastify"
import { OperationMiddleware } from "../../middlewares/operation"
import { Schemas } from "../../schemas"
import { fetchProcedure } from "../../services/prisma/procedures/fetch"
import { updateProcedure } from "../../services/prisma/procedures/update"
import { CustomTypePatch } from "../../types/request/procedures"
import { statusCode } from "../../utils/statusCode"

export default async function PatchProcedures(server: FastifyInstance) {
  server.patch<CustomTypePatch>(
    "/procedures",
    {
      preHandler: OperationMiddleware,
      schema: Schemas.procedures.patch
    },
    async (request: FastifyRequest<CustomTypePatch>, reply: FastifyReply) => {
      const { id } = request.query
      const { name, description, dosage } = request.body

      try {
        const procedure = { id, name, description, dosage }

        const hasProcedure = await fetchProcedure(id)
        if (!hasProcedure) {
          return reply.status(statusCode.notFound.status).send({
            error: statusCode.notFound.error,
            description: "We were unable to locate the procedure"
          })
        }

        const data = await updateProcedure(procedure)
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
