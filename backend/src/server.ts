import cors from "@fastify/cors"
import swagger, { FastifyDynamicSwaggerOptions } from "@fastify/swagger"
import swaggerUI, { FastifySwaggerUiOptions } from "@fastify/swagger-ui"
import fastify, { FastifyInstance } from "fastify"
import { SwaggerDocConfig } from "./docs/swagger"
import { SwaggerUIDocConfig } from "./docs/swaggerUI"
import RoutesInitController from "./routes"

const server: FastifyInstance = fastify({ logger: true })
RoutesInitController(server)

server.register(cors, {
  origin: "*",
  methods: ["GET", "PUT", "PATCH", "POST", "DELETE"],
  allowedHeaders: ["Content-Type", "authorization"],
  credentials: true
})

server.register(
  swagger,
  () => SwaggerDocConfig() as FastifyDynamicSwaggerOptions
)
server.register(
  swaggerUI,
  () => SwaggerUIDocConfig() as FastifySwaggerUiOptions
)

server.listen({ port: 7001, host: "0.0.0.0" }, err => {
  server.swagger()

  if (err) {
    console.error(err)
    process.exit(1)
  }

  console.log(`Server is running...`)
})
