export type createAnimalParams = {
  homeId: string
  name: string
  description: string
  castrated: boolean
  race: string
  sex: string
  typeAnimalId: number
  dateExit?: Date
  linkPhoto?: string
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
  linkPhoto?: string
  status?: boolean
}
