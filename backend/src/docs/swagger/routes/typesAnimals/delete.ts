export const DeleteConfigTypesAnimals = {
  tags: ["Type of Animals"],
  summary: "Delete type of animal",
  description: "This route allows the admin to delete the type of animal",
  produces: ["application/json"],
  operationId: "deleteTypeAnimalByID",
  security: [
    {
      authorization: []
    }
  ],
  parameters: [
    {
      name: "id",
      in: "query",
      description: "Enter the ID type of animal",
      required: true,
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
    "404": {
      description: "We were unable to locate the type of animal",
      error: "Not Found"
    },
    "401": {
      description: "Collaborator not authorized for this operation",
      error: "Unauthorized"
    },
    "403": {
      description: "Token was not provided",
      error: "Forbidden"
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
