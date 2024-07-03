import { VerifyEntityParams } from "../types/general"

export const useGetArrayEntity = async ({
  listEntity,
  functionGet
}: VerifyEntityParams) => {
  const resultQuery = await Promise.all(
    listEntity.map(async entity => {
      const result = await functionGet(entity.id)
      return result
    })
  )

  return resultQuery
}
