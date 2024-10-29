import { Document } from "@prisma/client"

export type createAnimalParams = {
  homeId: string
  name: string
  description: string
  castrated: boolean
  race: string
  sex: string
  typeAnimalId: number
  dateExit?: Date
  documents?: Document[]
}

export type updateAnimalParams = {
  id: string
  homeId?: string
  name?: string
  description?: string
  castrated?: boolean
  race?: string
  sex?: string
  typeAnimalId?: number
  dateExit?: Date
  documents?: Document[]
  status?: boolean
}
