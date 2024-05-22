import { verify } from "../utils/jwt"

export const useVerifyTokenAuth = async (token: string) => {
  const decodedToken = await verify(token)
  console.log(decodedToken)
  return false
}
