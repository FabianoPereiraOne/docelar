import { FastifyInstance, FastifyReply, FastifyRequest } from "fastify"
import { OperationMiddleware } from "../../middlewares/operation"
import { Schemas } from "../../schemas"
import { deleteDoctor } from "../../services/prisma/doctors/delete"
import { fetchDoctor } from "../../services/prisma/doctors/fetch"
import { CustomTypeDelete } from "../../types/request/general"
import { statusCode } from "../../utils/statusCode"

export default async function DeleteDoctors(server: FastifyInstance) {
  server.delete<CustomTypeDelete>(
    "/doctors",
    {
      preHandler: OperationMiddleware,
      schema: Schemas.general.delete
    },
    async (request: FastifyRequest<CustomTypeDelete>, reply: FastifyReply) => {
      const { id } = request.query

      try {
        const doctor = await fetchDoctor(id)
        const hasDoctor = !!doctor
        if (!hasDoctor) {
          return reply.status(statusCode.notFound.status).send({
            error: statusCode.notFound.error,
            description: "We were unable to locate the doctor"
          })
        }

        const hasServicesLinked = doctor.services.length > 0

        if (hasServicesLinked) {
          return reply.status(statusCode.conflict.status).send({
            error: statusCode.conflict.error,
            description: "Unable to delete the doctor with linked services"
          })
        }

        const data = await deleteDoctor(id)
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
