import { FastifyInstance, FastifyReply, FastifyRequest } from "fastify"
import { createWriteStream } from "fs"
import { mkdir, unlink } from "fs/promises"
import path from "path"
import useClearString from "../../hooks/useClearString"
import { OperationMiddleware } from "../../middlewares/operation"
import { fetchDocument } from "../../services/prisma/documents/fetch"
import { updateDocument } from "../../services/prisma/documents/update"
import { CustomTypePatch } from "../../types/request/documents"
import { statusCode } from "../../utils/statusCode"

export default async function PatchDocuments(server: FastifyInstance) {
  server.patch<CustomTypePatch>(
    "/documents",
    {
      preHandler: OperationMiddleware
    },
    async (request: FastifyRequest<CustomTypePatch>, reply: FastifyReply) => {
      const { clearString } = useClearString()
      const body = request.body
      const animalId: any = body?.animalId?.value ?? undefined
      const serviceId = body?.serviceId?.value ?? undefined
      const idQuery = body?.id?.value ?? undefined
      const idFormatted = Number(idQuery)
      const id = isNaN(idFormatted) ? 0 : idFormatted
      const files = body?.file

      if (!id) {
        return reply.status(statusCode.badRequest.status).send({
          error: statusCode.badRequest.error,
          description: "Document ID is required."
        })
      }

      try {
        const hasDocument = await fetchDocument({ id })
        if (!hasDocument) {
          return reply.status(statusCode.notFound.status).send({
            error: statusCode.notFound.error,
            description: "We were unable to locate document"
          })
        }

        if (files) {
          const keyOld = hasDocument?.key
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
          }).then(async () => {
            const replacePaste = new RegExp(`^/uploads/`)
            const filePath = path.resolve(
              process.cwd(),
              "public",
              "uploads",
              keyOld.replace(replacePaste, "")
            )

            await unlink(filePath)
          })

          const data = await updateDocument({
            id,
            key,
            animalId,
            serviceId
          })

          return reply.status(statusCode.success.status).send({
            data
          })
        }

        const data = await updateDocument({
          id,
          animalId,
          serviceId
        })

        return reply.status(statusCode.success.status).send({
          data
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
