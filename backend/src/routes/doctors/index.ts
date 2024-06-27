import { FastifyInstance } from "fastify"
import DeleteDoctors from "./delete"
import GetDoctors from "./get"
import GetAllDoctors from "./getAll"
import PatchDoctors from "./patch"
import PostDoctors from "./post"

export default async function Doctors(server: FastifyInstance) {
  server.register(PostDoctors)
  server.register(PatchDoctors)
  server.register(DeleteDoctors)
  server.register(GetDoctors)
  server.register(GetAllDoctors)
}
