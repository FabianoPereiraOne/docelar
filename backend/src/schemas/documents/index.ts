import { deleteProperties } from "./delete"
import { getProperties } from "./get"
import { patchProperties } from "./patch"
import { postProperties } from "./post"

export const schemaDocuments = {
  get: getProperties,
  post: postProperties,
  patch: patchProperties,
  delete: deleteProperties
}
