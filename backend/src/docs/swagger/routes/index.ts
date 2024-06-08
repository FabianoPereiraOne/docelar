import { PathCollaborator } from "./collaborator"
import { PathCollaborators } from "./collaborators"
import { PathSign } from "./sign"

export const SwaggerRoutes = {
  "/sign": PathSign,
  "/collaborators": PathCollaborators,
  "/collaborator": PathCollaborator
}
