import { FastifyInstance } from "fastify"
import PostModel from "./post"

export default async function Model(server: FastifyInstance) {
  server.register(PostModel)
}
