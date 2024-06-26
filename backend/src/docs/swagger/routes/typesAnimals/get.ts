export const GetConfigTypesAnimals = {
  tags: ["Type of Animals"],
  summary: "Search for type of animal",
  description: "This route allows you to search for a type of animal by ID",
  produces: ["application/json"],
  operationId: "getTypeAnimalByID",
  security: [
    {
      authorization: []
    }
  ],
  parameters: [
    {
      name: "id",
      in: "path",
      description: "ID Type of Animal",
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
      description: "params/id must be number",
      error: "Bad Request"
    },
    "404": {
      description: "We were unable to locate the type of animal",
      error: "Not Found"
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
