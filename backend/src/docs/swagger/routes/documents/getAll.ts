export const GetAllConfigDocuments = {
  tags: ["Documents"],
  summary: "Find all documents",
  description: "This route allows you to search for all documents",
  produces: ["application/json"],
  operationId: "getAllDocuments",
  security: [
    {
      authorization: []
    }
  ],
  responses: {
    "200": {
      description: "OK",
      schema: {
        type: "object",
        properties: {
          data: {
            type: "array",
            items: {
              type: "object",
              properties: {
                id: {
                  type: "number"
                },
                key: {
                  type: "string"
                },
                animalId: {
                  type: "string"
                },
                serviceId: {
                  type: "string"
                },
                createdAt: {
                  type: "string"
                },
                updateAt: {
                  type: "string"
                }
              }
            }
          }
        }
      }
    },
    "403": {
      description: "Token was not provided",
      error: "Forbidden"
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
