import { Document } from "@prisma/client"

export type CustomTypePost = {
  Body: {
    animalId: string
    description: string
    procedures: {
      id: number
    }[]
    doctors?: {
      id: string
    }[]
    documents?: Document[]
  }
}

export type CustomTypePatch = {
  Body: {
    id: string
    description?: string
    status?: boolean
    animalId?: string
    procedures?: {
      id: number
    }[]
    doctors?: {
      id: string
    }[]
    documents?: Document[]
  }
}
