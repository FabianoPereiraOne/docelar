import { DeleteConfigAnimals } from "./delete"
import { GetAllConfigAnimals } from "./getAll"
import { PatchConfigAnimals } from "./patch"
import { PostConfigAnimals } from "./post"

export const PathAnimals = {
  get: GetAllConfigAnimals,
  post: PostConfigAnimals,
  delete: DeleteConfigAnimals,
  patch: PatchConfigAnimals
}
