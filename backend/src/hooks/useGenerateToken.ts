import { sign } from "../utils/jwt"

export const useGenerateToken = async (id: string, email: string) => {
  const result = await sign({ id, email })
  return result
}
