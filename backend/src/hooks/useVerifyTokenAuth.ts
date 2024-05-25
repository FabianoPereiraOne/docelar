import { fetch } from "../services/prisma/collaborator/fetch"
import { verify } from "../utils/jwt"

export const useVerifyTokenAuth = async (token: string) => {
  const decodedToken = await verify(token)

  if (typeof decodedToken == "string")
    throw new Error("Unable to validate token")

  const result = await fetch(decodedToken.id)

  return result
}
