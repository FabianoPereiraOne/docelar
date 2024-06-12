import { FastifyInstance } from "fastify"
import DeleteCollaborators from "./delete"
import GetCollaborators from "./get"
import GetAllCollaborators from "./getAll"
import PatchCollaborators from "./patch"
import PostCollaborators from "./post"

export default async function Collaborators(server: FastifyInstance) {
  server.register(PostCollaborators)
  server.register(PatchCollaborators)
  server.register(GetCollaborators)
  server.register(DeleteCollaborators)
  server.register(GetAllCollaborators)
}
