import fastify, { FastifyInstance } from "fastify"

const server: FastifyInstance = fastify()

server.get("/", async () => {
  return { message: "Hello World!" }
})

server.listen({ port: 8080 }, err => {
  if (err) {
    console.error(err)
    process.exit(1)
  }
  console.log(`Servidor foi inicializado!`)
})
