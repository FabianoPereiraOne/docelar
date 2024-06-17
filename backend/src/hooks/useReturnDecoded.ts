import { PayloadType } from "../types/payload"
import { verify } from "../utils/jwt"

export const useReturnDecoded = async (authorization: string) => {
  const decoded = await verify(authorization)

  if (typeof decoded != "string")
    return { id: decoded.id, email: decoded.email } as PayloadType
}
