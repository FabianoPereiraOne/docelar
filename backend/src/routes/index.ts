import { FastifyInstance } from "fastify"
import Collaborators from "./collaborators"
import Homes from "./homes"
import Sign from "./sign"

export default async function RoutesInitController(server: FastifyInstance) {
  Collaborators(server)
  Sign(server)
  Homes(server)
}
