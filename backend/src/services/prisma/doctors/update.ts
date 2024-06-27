import { prisma } from "../../../database/prisma-client"
import { DoctorParamsUpdate } from "../../../types/doctor"

export const updateDoctor = async ({
  id,
  address,
  cep,
  city,
  crmv,
  district,
  expertise,
  name,
  number,
  openHours,
  phone,
  socialReason,
  state,
  status
}: DoctorParamsUpdate) => {
  const result = await prisma.doctor.update({
    data: {
      address,
      cep,
      city,
      crmv,
      district,
      expertise,
      name,
      number,
      openHours,
      phone,
      socialReason,
      state,
      status
    },
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
