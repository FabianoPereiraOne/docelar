import bcrypt from "bcrypt"

export const useGenerateHash = async (password: string) => {
  const salt = 10
  const hashGenerate = await bcrypt.hash(password, salt)
  return hashGenerate
}
