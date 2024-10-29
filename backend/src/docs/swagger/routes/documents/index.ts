import { DeleteConfigDocuments } from "./delete"
import { GetAllConfigDocuments } from "./getAll"
import { PatchConfigDocuments } from "./patch"
import { PostConfigDocuments } from "./post"

export const PathDocuments = {
  get: GetAllConfigDocuments,
  post: PostConfigDocuments,
  delete: DeleteConfigDocuments,
  patch: PatchConfigDocuments
}
