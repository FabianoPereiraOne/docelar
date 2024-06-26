import { DeleteConfigTypesAnimals } from "./delete"
import { GetAllConfigTypesAnimals } from "./getAll"
import { PatchConfigTypesAnimals } from "./patch"
import { PostConfigTypesAnimals } from "./post"

export const PathTypesAnimals = {
  get: GetAllConfigTypesAnimals,
  post: PostConfigTypesAnimals,
  delete: DeleteConfigTypesAnimals,
  patch: PatchConfigTypesAnimals
}
