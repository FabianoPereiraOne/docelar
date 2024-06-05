import { FastifyInstance } from "fastify"
import DeleteCollaborator from "./delete"
import GetCollaborator from "./get"
import PostCollaborator from "./post"
import PutCollaborator from "./put"

export default async function Collaborator(server: FastifyInstance) {
  server.register(PostCollaborator)
  server.register(PutCollaborator)
  server.register(GetCollaborator)
  server.register(DeleteCollaborator)
}
