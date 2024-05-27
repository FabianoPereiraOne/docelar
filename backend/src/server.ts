import fastify, { FastifyInstance } from "fastify"
import RoutesInitController from "./routes"

const server: FastifyInstance = fastify()

RoutesInitController(server)

server.listen({ port: 8080 }, err => {
  if (err) {
    console.error(err)
    process.exit(1)
  }

  console.log("Server is running...")
})
