import { DeleteConfigServices } from "./delete"
import { GetAllConfigServices } from "./getAll"
import { PatchConfigServices } from "./patch"
import { PostConfigServices } from "./post"

export const PathServices = {
  get: GetAllConfigServices,
  post: PostConfigServices,
  delete: DeleteConfigServices,
  patch: PatchConfigServices
}
