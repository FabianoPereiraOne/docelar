import { fetchCollaboratorByID } from "../services/collaborator"
import { verify } from "../utils/jwt"

export const useVerifyTokenAuth = async (token: string) => {
  const decodedToken = await verify(token)

  if (typeof decodedToken == "string")
    throw new Error("Unable to validate token")

  const result = await fetchCollaboratorByID(decodedToken.id)

  return result
}
