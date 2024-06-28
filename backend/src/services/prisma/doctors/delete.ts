import { prisma } from "../../../database/prisma-client"

export const deleteDoctor = async (id: string) => {
  const result = await prisma.doctor.delete({
    where: {
      id
    },
    select: {
      id: true,
      name: true,
      crmv: true,
      expertise: true,
      phone: true,
      socialReason: true,
      cep: true,
      state: true,
      city: true,
      district: true,
      address: true,
      number: true,
      openHours: true,
      status: true,
      createdAt: true,
      updatedAt: true,
      services: true
    }
  })

  return result
}
