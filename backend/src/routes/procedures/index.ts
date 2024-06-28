import { FastifyInstance } from "fastify"
import DeleteProcedures from "./delete"
import GetProcedures from "./get"
import GetAllProcedures from "./getAll"
import PatchProcedures from "./patch"
import PostProcedures from "./post"

export default async function Procedures(server: FastifyInstance) {
  server.register(DeleteProcedures)
  server.register(GetProcedures)
  server.register(GetAllProcedures)
  server.register(PatchProcedures)
  server.register(PostProcedures)
}
