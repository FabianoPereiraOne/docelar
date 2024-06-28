export const PatchConfigAnimals = {
  tags: ["Animals"],
  summary: "Update animal",
  description: "This route allows the admin to update a animal",
  produces: ["application/json"],
  operationId: "updateAnimal",
  security: [
    {
      authorization: []
    }
  ],
  parameters: [
    {
      name: "body",
      in: "body",
      required: false,
      description: "Enter the data for update",
      schema: {
        type: "object",
        properties: {
          name: {
            type: "string",
            example: "Scooby"
          },
          description: {
            type: "string",
            example: "Cão Bravo"
          },
          sex: {
            type: "string",
            example: "M"
          },
          castrated: {
            type: "boolean",
            example: true
          },
          race: {
            type: "string",
            example: "Lavrador"
          },
          status: {
            type: "boolean",
            example: false
          },
          linkPhoto: {
            type: "string",
            example:
              "https://unsplash.com/fotografias/labrador-retriever-amarelo-mordendo-flor-amarela-da-tulipa-Sg3XwuEpybU"
          },
          dateExit: {
            type: "string",
            example: "20/06/2024 14:36:23"
          },
          homeId: {
            type: "string",
            example: "56465fb2-72f2-48ff-8846-2d489a171fff"
          },
          typeAnimalId: {
            type: "number",
            example: 1
          }
        }
      }
    },
    {
      name: "id",
      in: "query",
      required: true,
      description: "Enter the ID animal",
      type: "string"
    }
  ],
  responses: {
    "200": {
      description: "OK",
      schema: {
        $ref: "#/definitions/Animal"
      }
    },
    "400": {
      description:
        "querystring must have required property 'id'\nbody/property must match pattern",
      error: "Bad Request"
    },
    "401": {
      description: "Collaborator not authorized for this operation",
      error: "Unauthorized"
    },
    "403": {
      description: "Token was not provided",
      error: "Forbidden"
    },
    "404": {
      description: "We were unable to locate the property",
      error: "Not Found"
    },
    "422": {
      description: "This token is not valid",
      error: "Unprocessable Entity"
    },
    "500": {
      description:
        "Something unexpected happened during processing on the server",
      error: "Internal Server Error"
    }
  }
}
