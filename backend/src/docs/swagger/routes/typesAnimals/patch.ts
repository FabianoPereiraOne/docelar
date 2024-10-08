export const PatchConfigTypesAnimals = {
  tags: ["Type of Animals"],
  summary: "Update type of animal",
  description: "This route allows the admin to update the type of animal",
  produces: ["application/json"],
  operationId: "updateTypeAnimal",
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
          id: {
            type: "number",
            example: 1
          },
          type: {
            type: "string",
            example: "Gato"
          }
        }
      }
    }
  ],
  responses: {
    "200": {
      description: "OK",
      schema: {
        $ref: "#/definitions/TypesAnimal"
      }
    },
    "400": {
      description:
        "Animal Type ID is required. \nBody/property must match pattern.",
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
      description: "We were unable to locate the type of animal",
      error: "Not Found"
    },
    "422": {
      description: "This token is not valid",
      error: "Unprocessable Entity"
    },
    "498": {
      description: "The token has expired. Please refresh your token",
      error: "Token Expired"
    },
    "500": {
      description:
        "Something unexpected happened during processing on the server",
      error: "Internal Server Error"
    }
  }
}
