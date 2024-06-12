import { deleteProperties } from "./delete"
import { getProperties } from "./get"
import { patchProperties } from "./patch"
import { postProperties } from "./post"

export const schemaCollaborators = {
  get: getProperties,
  delete: deleteProperties,
  post: postProperties,
  patch: patchProperties
}
