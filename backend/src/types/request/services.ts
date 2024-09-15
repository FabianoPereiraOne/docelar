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
  }
}
