import { FastifyReply } from "fastify"
import { fetchCollaborator } from "../services/prisma/collaborators/fetch"
import { verify } from "../utils/jwt"

export const useVerifyToken = async (token: string, reply: FastifyReply) => {
  const decodedToken = await verify(token, reply)

  if (!decodedToken || typeof decodedToken == "string") {
    throw new Error("Unable to validate token")
  }

  const result = await fetchCollaborator(decodedToken.id)
  return result
}
