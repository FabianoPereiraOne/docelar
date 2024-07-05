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
  Querystring: {
    id: string
  }
}
