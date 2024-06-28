import { DeleteConfigDoctors } from "./delete"
import { GetAllConfigDoctors } from "./getAll"
import { PatchConfigDoctors } from "./patch"
import { PostConfigDoctors } from "./post"

export const PathDoctors = {
  get: GetAllConfigDoctors,
  post: PostConfigDoctors,
  delete: DeleteConfigDoctors,
  patch: PatchConfigDoctors
}
