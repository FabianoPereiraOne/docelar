import { FastifyInstance } from "fastify"
import DeleteServices from "./delete"
import GetServices from "./get"
import GetAllServices from "./getAll"
import PatchServices from "./patch"
import PostServices from "./post"

export default async function Services(server: FastifyInstance) {
  server.register(PostServices)
  server.register(PatchServices)
  server.register(DeleteServices)
  server.register(GetAllServices)
  server.register(GetServices)
}
