import { FastifyInstance, FastifyReply, FastifyRequest } from "fastify"
import { createWriteStream } from "fs"
import { mkdir } from "fs/promises"
import path from "path"
import useClearString from "../../hooks/useClearString"
import { OperationMiddleware } from "../../middlewares/operation"
import { createDocument } from "../../services/prisma/documents/create"
import { CustomTypePost } from "../../types/request/documents"
import { statusCode } from "../../utils/statusCode"

export default async function PostDocuments(server: FastifyInstance) {
  server.post<CustomTypePost>(
    "/documents",
    {
      preHandler: OperationMiddleware
    },
    async (request: FastifyRequest<CustomTypePost>, reply: FastifyReply) => {
      const { clearString } = useClearString()

      try {
        const body = request.body
        const animalId: any = body?.animalId?.value ?? undefined
        const serviceId = body?.serviceId?.value ?? undefined
        const files = body?.file

        if (!files) {
          return reply.status(statusCode.badRequest.status).send({
            error: statusCode.badRequest.error,
            description: "File is required"
          })
        }

        const timestamp = Date.now()
        const originalFileName = clearString(files?.filename)
        const fileExtension = path.extname(originalFileName)
        const fileBaseName = path.basename(originalFileName, fileExtension)
        const newFileName = `${fileBaseName}-${timestamp}${fileExtension}`
        const filePath = path.resolve(
          process.cwd(),
          "public",
          "uploads",
          newFileName
        )

        const dir = path.dirname(filePath)
        await mkdir(dir, { recursive: true })

        const fileStream = await files.toBuffer()
        const key = `/uploads/${newFileName}`
        const writeStream = createWriteStream(filePath)

        await new Promise((resolve, reject) => {
          writeStream.write(fileStream, err => {
            if (err) {
              reject(err)
            } else {
              resolve(null)
            }
          })
          writeStream.end()
        })

        const result = await createDocument({ key, animalId, serviceId })

        return reply.status(statusCode.create.status).send({
          success: statusCode.create.success,
          data: result
        })
      } catch (error) {
        console.error(error)
        return reply.status(statusCode.serverError.status).send({
          error: statusCode.serverError.error,
          description:
            "Something unexpected happened during processing on the server"
        })
      }
    }
  )
}
