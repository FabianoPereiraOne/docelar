export type CustomTypePost = {
  Body: {
    name: string
    description: string
    sex: string
    castrated: boolean
    race: string
    linkPhoto?: string
    dateExit?: Date
    typeAnimalId: number
  }
  Querystring: {
    homeId: string
  }
}

export type CustomTypePatch = {
  Body: {
    id: string
    name?: string
    description?: string
    sex?: string
    castrated?: boolean
    race?: string
    linkPhoto?: string
    dateExit?: Date
    typeAnimalId?: number
    status?: boolean
    homeId?: string
  }
}
