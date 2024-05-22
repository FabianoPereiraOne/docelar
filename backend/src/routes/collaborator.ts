import { FastifyInstance } from "fastify"
import { authMiddleware } from "../middlewares/auth"

export default async function Collaborator(app: FastifyInstance) {
  app.post(
    "/collaborator",
    { preHandler: authMiddleware },
    async (req, res) => {
      return res.send("Hello world").status(200)
    }
  )
}
