import { FastifyInstance, FastifyReply, FastifyRequest } from "fastify"
import { OperationMiddleware } from "../../middlewares/operation"
import { Schemas } from "../../schemas"
import { fetchDoctor } from "../../services/prisma/doctors/fetch"
import { updateDoctor } from "../../services/prisma/doctors/update"
import { CustomTypePatch } from "../../types/request/doctors"
import { statusCode } from "../../utils/statusCode"

export default async function PatchDoctors(server: FastifyInstance) {
  server.patch<CustomTypePatch>(
    "/doctors",
    {
      preHandler: OperationMiddleware,
      schema: Schemas.doctors.patch
    },
    async (request: FastifyRequest<CustomTypePatch>, reply: FastifyReply) => {
      const {
        address,
        cep,
        city,
        crmv,
        district,
        expertise,
        name,
        number,
        openHours,
        phone,
        socialReason,
        state,
        status,
        id
      } = request.body

      if (!id) {
        return reply.status(statusCode.badRequest.status).send({
          error: statusCode.badRequest.error,
          description: "Doctor ID is required"
        })
      }

      try {
        const hasDoctor = !!(await fetchDoctor(id))

        if (!hasDoctor) {
          return reply.status(statusCode.notFound.status).send({
            error: statusCode.notFound.error,
            description: "We were unable to locate the doctor"
          })
        }

        const doctor = {
          id,
          address,
          cep,
          city,
          crmv,
          district,
          expertise,
          name,
          number,
          openHours,
          phone,
          socialReason,
          state,
          status
        }

        const data = await updateDoctor(doctor)
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
