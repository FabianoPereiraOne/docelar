import { PathCollaborators } from "./collaborators"
import { GetConfigCollaborators } from "./collaborators/get"
import { PathHomes } from "./homes"
import { GetConfigHomes } from "./homes/get"
import { PathSign } from "./sign"

export const SwaggerRoutes = {
  "/sign": PathSign,
  "/collaborators": PathCollaborators,
  "/homes": PathHomes,

  "/collaborators/{id}": { get: GetConfigCollaborators },
  "/homes/{id}": { get: GetConfigHomes }
}
