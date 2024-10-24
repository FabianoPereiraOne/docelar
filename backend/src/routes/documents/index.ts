import { FastifyInstance } from "fastify"
import DeleteDocuments from "./delete"
import GetDocuments from "./get"
import GetAllDocuments from "./getAll"
import PatchDocuments from "./patch"
import PostDocuments from "./post"

export default async function Documents(server: FastifyInstance) {
  server.register(PostDocuments)
  server.register(PatchDocuments)
  server.register(GetAllDocuments)
  server.register(DeleteDocuments)
  server.register(GetDocuments)
}
