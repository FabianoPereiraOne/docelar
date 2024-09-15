import { FastifyInstance, FastifyReply, FastifyRequest } from "fastify"
import { unlink } from "fs/promises"
import path from "path"
import { OperationMiddleware } from "../../middlewares/operation"
import { CustomTypeDelete } from "../../types/request/upload"
import { statusCode } from "../../utils/statusCode"

export default async function DeleteUpload(server: FastifyInstance) {
  server.delete<CustomTypeDelete>(
    "/upload",
    {
      preHandler: OperationMiddleware
    },
    async (request: FastifyRequest<CustomTypeDelete>, reply: FastifyReply) => {
      const { key } = request.query

      if (!key) {
        return reply.status(statusCode.badRequest.status).send({
          error: statusCode.badRequest.error,
          description: "File key is required."
        })
      }

      try {
        const replacePaste = new RegExp(`^/uploads/`)
        const filePath = path.resolve(
          process.cwd(),
          "public",
          "uploads",
          key.replace(replacePaste, "")
        )

        await unlink(filePath)

        return reply
          .status(statusCode.success.status)
          .send({ success: "File deleted successfully." })
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
