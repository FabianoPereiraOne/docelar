import { DeleteConfigCollaborator } from "./delete"
import { GetConfigCollaborator } from "./get"
import { PostConfigCollaborator } from "./post"
import { PutConfigCollaborator } from "./put"

export const PathCollaborator = {
  get: GetConfigCollaborator,
  post: PostConfigCollaborator,
  delete: DeleteConfigCollaborator,
  put: PutConfigCollaborator
}
