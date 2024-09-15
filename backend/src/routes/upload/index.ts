import { FastifyInstance } from "fastify"
import DeleteUpload from "./delete"
import PostUpload from "./post"

export default async function Upload(server: FastifyInstance) {
  server.register(PostUpload)
  server.register(DeleteUpload)
}
