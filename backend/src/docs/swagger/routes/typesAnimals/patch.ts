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
          type: {
            type: "string",
            example: "Gato"
          }
        }
      }
    },
    {
      name: "id",
      in: "query",
      required: true,
      description: "Enter the ID type of animal",
      type: "number"
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
      description: "querystring must have required property 'id'",
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
    "500": {
      description:
        "Something unexpected happened during processing on the server",
      error: "Internal Server Error"
    }
  }
}
