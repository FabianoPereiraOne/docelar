import { FastifyInstance, FastifyReply, FastifyRequest } from "fastify"
import { OperationMiddleware } from "../../middlewares/operation"
import { Schemas } from "../../schemas"
import { fetchCollaborator } from "../../services/prisma/collaborators/fetch"
import { createHome } from "../../services/prisma/homes/create"
import { CustomTypePost } from "../../types/request/homes"
import { statusCode } from "../../utils/statusCode"

export default async function PostHomes(server: FastifyInstance) {
  server.post<CustomTypePost>(
    "/homes",
    {
      preHandler: OperationMiddleware,
      schema: Schemas.homes.post
    },
    async (request: FastifyRequest<CustomTypePost>, reply: FastifyReply) => {
      const { cep, address, city, number, state, district, collaboratorId } =
        request.body

      if (!collaboratorId) {
        return reply.status(statusCode.badRequest.status).send({
          error: statusCode.badRequest.error,
          description: "Collaborator ID is required"
        })
      }

      try {
        const hasCollaboratorId = !!(await fetchCollaborator(collaboratorId))
        if (!hasCollaboratorId) {
          return reply.status(statusCode.notFound.status).send({
            error: statusCode.notFound.error,
            description: "We were unable to locate the collaborator"
          })
        }

        const home = {
          collaboratorId,
          cep,
          address,
          city,
          district,
          number,
          state
        }
        const data = await createHome(home)
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
