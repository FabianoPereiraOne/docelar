import { schemaAnimals } from "./animals"
import { schemaCollaborators } from "./collaborators"
import { schemaGeneral } from "./general"
import { schemaHomes } from "./homes"
import { schemaSign } from "./sign"

export const Schemas = {
  collaborators: schemaCollaborators,
  sign: schemaSign,
  homes: schemaHomes,
  general: schemaGeneral,
  animals: schemaAnimals
}
