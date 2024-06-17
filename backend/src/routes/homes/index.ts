import { FastifyInstance } from "fastify"
import DeleteHomes from "./delete"
import GetHomes from "./get"
import GetAllHomes from "./getAll"
import PatchHomes from "./patch"
import PostHomes from "./post"

export default async function Homes(server: FastifyInstance) {
  server.register(PostHomes)
  server.register(PatchHomes)
  server.register(DeleteHomes)
  server.register(GetHomes)
  server.register(GetAllHomes)
}
