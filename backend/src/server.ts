import swagger, { FastifyDynamicSwaggerOptions } from "@fastify/swagger"
import swaggerUI, { FastifySwaggerUiOptions } from "@fastify/swagger-ui"
import fastify, { FastifyInstance } from "fastify"
import swaggerDocs from "../swagger.json"
import swaggerUIDocs from "../swaggerUI.json"
import RoutesInitController from "./routes"

const server: FastifyInstance = fastify()
RoutesInitController(server)

server.register(swagger, swaggerDocs as FastifyDynamicSwaggerOptions)
server.register(swaggerUI, swaggerUIDocs as FastifySwaggerUiOptions)

server.listen({ port: 8080 }, err => {
  server.swagger()

  if (err) {
    console.error(err)
    process.exit(1)
  }

  console.log("Server is running...")
})
