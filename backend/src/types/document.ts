export type DocumentPostParams = {
  key: string
  animalId?: string
  serviceId?: string
}

export type DocumentPatchParams = {
  id: number
  key?: string
  animalId?: string
  serviceId?: string
}
