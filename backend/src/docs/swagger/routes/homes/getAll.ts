export const GetAllConfigHomes = {
  tags: ["Homes"],
  summary: "Find all temporary homes",
  description: "This route allows you to search for all temporary homes",
  produces: ["application/json"],
  operationId: "getAllHomes",
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
                  type: "string"
                },
                cep: {
                  type: "string"
                },
                state: {
                  type: "string"
                },
                city: {
                  type: "string"
                },
                district: {
                  type: "string"
                },
                address: {
                  type: "string"
                },
                number: {
                  type: "string"
                },
                status: {
                  type: "boolean"
                },
                createdAt: {
                  type: "string"
                },
                updateAt: {
                  type: "string"
                },
                collaboratorId: {
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
    "500": {
      description:
        "Something unexpected happened during processing on the server",
      error: "Internal Server Error"
    }
  }
}
