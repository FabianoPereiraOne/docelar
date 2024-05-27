import { FastifyInstance } from "fastify"
import PatchCollaborator from "./patch"
import PostCollaborator from "./post"

export default async function Collaborator(server: FastifyInstance) {
  server.register(PostCollaborator)
  server.register(PatchCollaborator)
}
