export type CustomTypePost = {
  Body: {
    homeId: string
    name: string
    description: string
    sex: string
    castrated: boolean
    race: string
    linkPhoto?: string
    dateExit?: Date
    typeAnimalId: number
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
