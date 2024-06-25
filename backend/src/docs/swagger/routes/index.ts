import { PathAnimals } from "./animals"
import { GetConfigAnimals } from "./animals/get"
import { PathCollaborators } from "./collaborators"
import { GetConfigCollaborators } from "./collaborators/get"
import { PathHomes } from "./homes"
import { GetConfigHomes } from "./homes/get"
import { PathSign } from "./sign"

export const SwaggerRoutes = {
  "/sign": PathSign,
  "/collaborators": PathCollaborators,
  "/homes": PathHomes,
  "/animals": PathAnimals,

  "/collaborators/{id}": { get: GetConfigCollaborators },
  "/homes/{id}": { get: GetConfigHomes },
  "/animals/{id}": { get: GetConfigAnimals }
}
