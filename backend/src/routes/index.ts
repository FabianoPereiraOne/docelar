import { FastifyInstance } from "fastify"
import Collaborator from "./collaborator"

export default async function RoutesInitController(server: FastifyInstance) {
  Collaborator(server)
}
