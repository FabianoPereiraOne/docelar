import { FastifyInstance } from "fastify"
import Animals from "./animals"
import Collaborators from "./collaborators"
import Doctors from "./doctors"
import Homes from "./homes"
import Sign from "./sign"
import TypesAnimals from "./typesAnimals"

export default async function RoutesInitController(server: FastifyInstance) {
  Collaborators(server)
  Sign(server)
  Homes(server)
  Animals(server)
  TypesAnimals(server)
  Doctors(server)
}
