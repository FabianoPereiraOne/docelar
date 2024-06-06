import { FastifyInstance } from "fastify"
import DeleteCollaborator from "./delete"
import GetCollaborator from "./get"
import PatchCollaborator from "./patch"
import PostCollaborator from "./post"

export default async function Collaborator(server: FastifyInstance) {
  server.register(PostCollaborator)
  server.register(PatchCollaborator)
  server.register(GetCollaborator)
  server.register(DeleteCollaborator)
}
