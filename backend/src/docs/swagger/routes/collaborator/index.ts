import { DeleteConfigCollaborator } from "./delete"
import { GetConfigCollaborator } from "./get"
import { PatchConfigCollaborator } from "./patch"
import { PostConfigCollaborator } from "./post"

export const PathCollaborator = {
  get: GetConfigCollaborator,
  post: PostConfigCollaborator,
  delete: DeleteConfigCollaborator,
  patch: PatchConfigCollaborator
}
