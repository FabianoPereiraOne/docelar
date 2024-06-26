import { FastifyInstance } from "fastify"
import DeleteTypesAnimals from "./delete"
import GetTypesAnimals from "./get"
import GetAllTypesAnimals from "./getAll"
import PatchTypesAnimals from "./patch"
import PostTypesAnimals from "./post"

export default async function TypesAnimals(server: FastifyInstance) {
  server.register(PostTypesAnimals)
  server.register(PatchTypesAnimals)
  server.register(GetAllTypesAnimals)
  server.register(DeleteTypesAnimals)
  server.register(GetTypesAnimals)
}
