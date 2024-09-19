export const PatchConfigHomes = {
  tags: ["Homes"],
  summary: "Update temporary home",
  description: "This route allows the admin to update a temporary home",
  produces: ["application/json"],
  operationId: "updateHome",
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
      description: "Enter the data for update",
      schema: {
        type: "object",
        properties: {
          id: {
            type: "string",
            example: "Enter the ID temporary home"
          },
          cep: {
            type: "string",
            example: "00000-000"
          },
          state: {
            type: "string",
            example: "Minas Gerais"
          },
          city: {
            type: "string",
            example: "Governador Valadares"
          },
          district: {
            type: "string",
            example: "Centro"
          },
          address: {
            type: "string",
            example: "Rua Jose da Silva"
          },
          number: {
            type: "string",
            example: "104b"
          },
          status: {
            type: "boolean"
          }
        }
      }
    }
  ],
  responses: {
    "200": {
      description: "OK",
      schema: {
        $ref: "#/definitions/Home"
      }
    },
    "400": {
      description: "Home ID is required. \nBody/property must match pattern.",
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
      description: "We were unable to locate the home",
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
