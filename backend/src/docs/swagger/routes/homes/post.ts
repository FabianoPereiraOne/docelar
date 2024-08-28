export const PostConfigHomes = {
  tags: ["Homes"],
  summary: "Create temporary home",
  description: "This route allows the admin to create a temporary home",
  produces: ["application/json"],
  operationId: "createHome",
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
          collaboratorId: {
            type: "string",
            example: "Enter the collaborator ID to link"
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
          }
        }
      }
    }
  ],
  responses: {
    "201": {
      description: "Created",
      schema: {
        $ref: "#/definitions/Home"
      }
    },
    "400": {
      description:
        "Collaborator ID is required.\n Body must have required property. \nBody/property must match pattern.",
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
      description: "We were unable to locate the collaborator",
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
