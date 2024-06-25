import { prisma } from "../../../database/prisma-client"
import { updateHomeParams } from "../../../types/home"

export const updateHome = async ({
  id,
  address,
  cep,
  city,
  number,
  district,
  state,
  status
}: updateHomeParams) => {
  const result = await prisma.home.update({
    data: {
      address,
      cep,
      city,
      district,
      number,
      state,
      status
    },
    where: {
      id
    },
    select: {
      id: true,
      cep: true,
      state: true,
      city: true,
      district: true,
      address: true,
      number: true,
      status: true,
      createdAt: true,
      updatedAt: true,
      collaboratorId: true,
      animals: true
    }
  })

  return result
}
