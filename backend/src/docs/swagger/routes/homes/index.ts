import { DeleteConfigHomes } from "./delete"
import { GetAllConfigHomes } from "./getAll"
import { PatchConfigHomes } from "./patch"
import { PostConfigHomes } from "./post"

export const PathHomes = {
  get: GetAllConfigHomes,
  post: PostConfigHomes,
  delete: DeleteConfigHomes,
  patch: PatchConfigHomes
}
