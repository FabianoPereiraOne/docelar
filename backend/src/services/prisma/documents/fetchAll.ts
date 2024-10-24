import { prisma } from "../../../database/prisma-client"

export const fetchAllDocuments = async () => {
  const result = await prisma.document.findMany()
  return result
}
