import fastifyCors from "@fastify/cors"
import fastifyMultipart from "@fastify/multipart"
import fastifyStatic from "@fastify/static"
import swagger, { FastifyDynamicSwaggerOptions } from "@fastify/swagger"
import swaggerUI, { FastifySwaggerUiOptions } from "@fastify/swagger-ui"
import fastify, { FastifyInstance } from "fastify"
import path from "path"
import { SwaggerDocConfig } from "./docs/swagger"
import { SwaggerUIDocConfig } from "./docs/swaggerUI"
import RoutesInitController from "./routes"

const server: FastifyInstance = fastify()
server.register(fastifyMultipart, {
  limits: {
    fileSize: 20 * 1024 * 1024
  }
})

server.register(fastifyStatic, {
  root: path.join(__dirname, "../public/uploads"),
  prefix: "/uploads/"
})

server.register(fastifyCors, {
  origin: "*",
  methods: ["GET", "POST", "PATCH", "DELETE"],
  allowedHeaders: ["Content-Type", "Authorization"]
})

RoutesInitController(server)

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
