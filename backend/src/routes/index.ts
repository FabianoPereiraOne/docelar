import { FastifyInstance } from "fastify"
import Collaborator from "./collaborator"
import Collaborators from "./collaborators"

export default async function RoutesInitController(server: FastifyInstance) {
  Collaborator(server)
  Collaborators(server)
}
