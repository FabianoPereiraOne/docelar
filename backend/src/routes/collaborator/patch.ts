import { FastifyInstance, FastifyReply, FastifyRequest } from "fastify"
import { useGenerateHash } from "../../hooks/useGenerateHash"
import { operationMiddleware } from "../../middlewares/operation"
import { fetch } from "../../services/prisma/collaborator/fetch"
import { update } from "../../services/prisma/collaborator/update"
import { CollaboratorParamsUpdate } from "../../types/collaborator"
import { statusCode } from "../../utils/statusCode"

export default async function PatchCollaborator(server: FastifyInstance) {
  server.patch(
    "/collaborator",
    { preHandler: operationMiddleware },
    async (request: FastifyRequest, reply: FastifyReply) => {
      const { id }: any = request.query
      const data: any = request.body
      const password = request.headers["password"]
      const hasID = !!id

      if (!hasID)
        return reply.status(statusCode.badRequest.status).send({
          statusCode: statusCode.badRequest.status,
          error: statusCode.badRequest.error,
          message: "Employee ID was not provided"
        })

      const hasCollaborator = !!(await fetch(id))
      if (!hasCollaborator)
        return reply.status(statusCode.notFound.status).send({
          statusCode: statusCode.notFound.status,
          error: statusCode.notFound.error,
          message: "We were unable to locate the employee"
        })

      try {
        const collaborator: CollaboratorParamsUpdate = {
          id,
          name: data?.name,
          email: data?.email,
          phone: data?.phone,
          type: data?.type,
          status: data?.status,
          password:
            password != undefined
              ? await useGenerateHash(password as string)
              : undefined
        }

        await update(collaborator).then(data => {
          return reply.status(statusCode.success.status).send({
            statusCode: statusCode.success.status,
            success: statusCode.success.success,
            message: "Collaborator successfully updated",
            data
          })
        })
      } catch (error) {
        return reply.send(error)
      }
    }
  )
}
