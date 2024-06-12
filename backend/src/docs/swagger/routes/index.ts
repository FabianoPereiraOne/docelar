import { PathCollaborators } from "./collaborators"
import { GetConfigCollaborators } from "./collaborators/get"
import { PathSign } from "./sign"

export const SwaggerRoutes = {
  "/sign": PathSign,
  "/collaborators": PathCollaborators,
  "/collaborators/{id}": { get: GetConfigCollaborators }
}
