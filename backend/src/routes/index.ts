import { FastifyInstance } from "fastify"
import Animals from "./animals"
import Collaborators from "./collaborators"
import Doctors from "./doctors"
import Homes from "./homes"
import Procedures from "./procedures"
import Services from "./services"
import Sign from "./sign"
import TypesAnimals from "./typesAnimals"
import Upload from "./upload"

export default async function RoutesInitController(server: FastifyInstance) {
  Collaborators(server)
  Sign(server)
  Homes(server)
  Animals(server)
  TypesAnimals(server)
  Doctors(server)
  Procedures(server)
  Services(server)
  Upload(server)
}
