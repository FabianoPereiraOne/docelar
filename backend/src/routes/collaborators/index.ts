import { FastifyInstance } from "fastify"
import GetCollaborators from "./get"

export default async function Collaborators(server: FastifyInstance) {
  server.register(GetCollaborators)
}
