import { prisma } from "../../../database/prisma-client"

export const fetchAllHomes = async () => {
  const result = await prisma.home.findMany()
  return result
}
