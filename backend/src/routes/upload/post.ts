import { FastifyInstance, FastifyReply, FastifyRequest } from "fastify"
import { createWriteStream } from "fs"
import { mkdir } from "fs/promises"
import path from "path"
import useClearString from "../../hooks/useClearString"
import { OperationMiddleware } from "../../middlewares/operation"
import { CustomTypePost } from "../../types/request/upload"
import { statusCode } from "../../utils/statusCode"
const { clearString } = useClearString()

export default async function PostUpload(server: FastifyInstance) {
  server.post<CustomTypePost>(
    "/upload",
    {
      preHandler: OperationMiddleware
    },
    async (request: FastifyRequest<CustomTypePost>, reply: FastifyReply) => {
      try {
        const data = await request.file()

        if (!data) {
          return reply.status(statusCode.badRequest.status).send({
            error: statusCode.badRequest.error,
            description: "File is required"
          })
        }

        const timestamp = Date.now()
        const originalFileName = clearString(data?.filename)
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

        const fileStream = data.file
        const key = `/uploads/${newFileName}`

        await new Promise((resolve, reject) => {
          const writeStream = createWriteStream(filePath)
          fileStream.pipe(writeStream)
          writeStream.on("finish", resolve)
          writeStream.on("error", reject)
        })

        return reply.status(statusCode.create.status).send({
          key
        })
      } catch (error) {
        console.log(error)
        return reply.status(statusCode.serverError.status).send({
          error,
          description:
            "Something unexpected happened during processing on the server"
        })
      }
    }
  )
}
