export type ServicePostParams = {
  description: string
  animalId: string
  listDoctors:
    | {
        id: string
      }[]
    | []
  listProcedures: {
    id: number
  }[]
}

export type ServicePatchParams = {
  id: string
  description?: string
  status?: boolean
  animalId?: string
  listDoctors:
    | {
        id: string
      }[]
    | []
  listProcedures:
    | {
        id: number
      }[]
    | []
  listDoctorsOld: string[]
  listProceduresOld: number[]
}
