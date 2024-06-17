import { FastifyInstance, FastifyReply, FastifyRequest } from "fastify"
import { OperationMiddleware } from "../../middlewares/operation"
import { Schemas } from "../../schemas"
import { CustomTypePost } from "../../types/request/homes"

export default async function PostModel(server: FastifyInstance) {
  server.post<CustomTypePost>(
    "/homes",
    {
      preHandler: OperationMiddleware,
      schema: Schemas.homes.post
    },
    async (request: FastifyRequest<CustomTypePost>, reply: FastifyReply) => {}
  )
}
