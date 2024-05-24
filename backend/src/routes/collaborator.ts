import { FastifyInstance, FastifyRequest } from "fastify"
import { authMiddleware } from "../middlewares/auth"

export default async function Collaborator(app: FastifyInstance) {
  app.post(
    "/collaborator",
    { preHandler: authMiddleware },
    async (request: FastifyRequest, res) => {
      const pass = request.headers["password"]
      const data = request.body

      return res.send("Hello world").status(200)
    }
  )
}
