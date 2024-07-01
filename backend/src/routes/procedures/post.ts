import { FastifyInstance, FastifyReply, FastifyRequest } from "fastify"
import { OperationMiddleware } from "../../middlewares/operation"
import { Schemas } from "../../schemas"
import { createProcedure } from "../../services/prisma/procedures/create"
import { CustomTypePost } from "../../types/request/procedures"
import { statusCode } from "../../utils/statusCode"

export default async function PostProcedures(server: FastifyInstance) {
  server.post<CustomTypePost>(
    "/procedures",
    {
      preHandler: OperationMiddleware,
      schema: Schemas.procedures.post
    },
    async (request: FastifyRequest<CustomTypePost>, reply: FastifyReply) => {
      const { name, description, dosage } = request.body

      try {
        const procedure = { name, description, dosage }
        const data = await createProcedure(procedure)
        return reply.status(statusCode.create.status).send({
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
