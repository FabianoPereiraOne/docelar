import fastify, { FastifyInstance } from "fastify"
import Collaborator from "./routes/collaborator"

const server: FastifyInstance = fastify()

server.register(Collaborator)

server.listen({ port: 8080 }, err => {
  if (err) {
    console.error(err)
    process.exit(1)
  }

  console.log("Server is running...")
})
