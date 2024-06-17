import { deleteProperties } from "./delete"
import { getProperties } from "./get"

export const schemaGeneral = {
  get: getProperties,
  delete: deleteProperties
}
