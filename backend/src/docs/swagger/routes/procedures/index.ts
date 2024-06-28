import { DeleteConfigProcedures } from "./delete"
import { GetAllConfigProcedures } from "./getAll"
import { PatchConfigProcedures } from "./patch"
import { PostConfigProcedures } from "./post"

export const PathProcedure = {
  get: GetAllConfigProcedures,
  post: PostConfigProcedures,
  delete: DeleteConfigProcedures,
  patch: PatchConfigProcedures
}
