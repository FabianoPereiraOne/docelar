export const PostConfigAnimals = {
  tags: ["Animals"],
  summary: "Create animal",
  description: "This route allows the admin to create a animal",
  produces: ["application/json"],
  operationId: "createAnimal",
  security: [
    {
      authorization: []
    }
  ],
  parameters: [
    {
      name: "body",
      in: "body",
      required: true,
      description: "Enter the data for registration",
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
          typeAnimalId: {
            type: "number",
            example: 1
          }
        }
      }
    },
    {
      name: "homeId",
      in: "query",
      required: true,
      description: "Enter the temporary home ID to link",
      type: "string"
    }
  ],
  responses: {
    "201": {
      description: "Created",
      schema: {
        $ref: "#/definitions/Animal"
      }
    },
    "400": {
      description:
        "querystring or body must have required property \nbody/property must match pattern",
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
