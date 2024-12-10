import fastifyCors from "@fastify/cors"
import fastifyMultipart from "@fastify/multipart"
import fastifyStatic from "@fastify/static"
import swagger, { FastifyDynamicSwaggerOptions } from "@fastify/swagger"
import swaggerUI, { FastifySwaggerUiOptions } from "@fastify/swagger-ui"
import { CronJob } from "cron"
import fastify, { FastifyInstance } from "fastify"
import path from "path"
import { SwaggerDocConfig } from "./docs/swagger"
import { SwaggerUIDocConfig } from "./docs/swaggerUI"
import useCreateBackup from "./hooks/useCreateBackup"
import RoutesInitController from "./routes"
const { createBackup } = useCreateBackup()

const server: FastifyInstance = fastify()

const serviceBackup = new CronJob(
  "0 2 * * *",
  async () => {
    try {
      console.log("Iniciando backup...")
      await createBackup()
    } catch (error) {
      console.error("Erro ao executar o backup:", error)
    }
  },
  null,
  true,
  "America/Sao_Paulo"
)

serviceBackup.start()

server.register(fastifyMultipart, {
  limits: {
    fileSize: 40 * 1024 * 1024
  },
  attachFieldsToBody: true
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
