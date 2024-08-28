export type CustomTypePost = {
  Body: {
    description: string
    procedures: {
      id: number
    }[]
    doctors: {
      id: string
    }[]
  }
  Querystring: {
    animalId: string
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
