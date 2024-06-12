import { FastifyInstance } from "fastify"
import Collaborators from "./collaborators"
import Sign from "./sign"

export default async function RoutesInitController(server: FastifyInstance) {
  Collaborators(server)
  Sign(server)
}
