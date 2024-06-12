import { DeleteConfigCollaborators } from "./delete"
import { GetAllConfigCollaborators } from "./getAll"
import { PatchConfigCollaborators } from "./patch"
import { PostConfigCollaborators } from "./post"

export const PathCollaborators = {
  get: GetAllConfigCollaborators,
  post: PostConfigCollaborators,
  delete: DeleteConfigCollaborators,
  patch: PatchConfigCollaborators
}
