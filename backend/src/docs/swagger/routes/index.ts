import { PathAnimals } from "./animals"
import { GetConfigAnimals } from "./animals/get"
import { PathCollaborators } from "./collaborators"
import { GetConfigCollaborators } from "./collaborators/get"
import { PathDoctors } from "./doctors"
import { GetConfigDoctors } from "./doctors/get"
import { PathHomes } from "./homes"
import { GetConfigHomes } from "./homes/get"
import { PathSign } from "./sign"
import { PathTypesAnimals } from "./typesAnimals"
import { GetConfigTypesAnimals } from "./typesAnimals/get"

export const SwaggerRoutes = {
  "/sign": PathSign,
  "/collaborators": PathCollaborators,
  "/homes": PathHomes,
  "/animals": PathAnimals,
  "/types-animals": PathTypesAnimals,
  "/doctors": PathDoctors,

  "/collaborators/{id}": { get: GetConfigCollaborators },
  "/homes/{id}": { get: GetConfigHomes },
  "/animals/{id}": { get: GetConfigAnimals },
  "/types-animals/{id}": { get: GetConfigTypesAnimals },
  "/doctors/{id}": { get: GetConfigDoctors }
}
