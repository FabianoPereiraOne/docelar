import { FastifyInstance, FastifyReply, FastifyRequest } from "fastify"
import { OperationMiddleware } from "../../middlewares/operation"
import { Schemas } from "../../schemas"
import { createDoctor } from "../../services/prisma/doctors/create"
import { CustomTypePost } from "../../types/request/doctors"
import { statusCode } from "../../utils/statusCode"

export default async function PostDoctors(server: FastifyInstance) {
  server.post<CustomTypePost>(
    "/doctors",
    {
      preHandler: OperationMiddleware,
      schema: Schemas.doctors.post
    },
    async (request: FastifyRequest<CustomTypePost>, reply: FastifyReply) => {
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
        state
      } = request.body

      try {
        const doctor = {
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
          state
        }

        const data = await createDoctor(doctor)
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
