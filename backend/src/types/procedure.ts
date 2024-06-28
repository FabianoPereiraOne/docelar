export type ProcedurePostParams = {
  name: string
  description: string
  dosage: string
}

export type ProcedurePatchParams = {
  id: number
  name?: string
  description?: string
  dosage?: string
}
