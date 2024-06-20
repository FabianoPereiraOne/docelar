import { FastifyInstance } from "fastify"
import DeleteAnimals from "./delete"
import GetAnimals from "./get"
import GetAllAnimals from "./getAll"
import PatchAnimals from "./patch"
import PostAnimals from "./post"

export default async function Animals(server: FastifyInstance) {
  server.register(PostAnimals)
  server.register(PatchAnimals)
  server.register(DeleteAnimals)
  server.register(GetAllAnimals)
  server.register(GetAnimals)
}
