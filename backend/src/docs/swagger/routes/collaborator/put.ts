export const PutConfigCollaborator = {
  tags: ["Collaborator"],
  summary: "Update collaborator",
  description: "This route allows the admin to update a collaborator",
  produces: ["application/json"],
  operationId: "updateCollaborator",
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
          collaborator: {
            type: "object",
            properties: {
              name: {
                type: "string",
                example: "Lucas Silva"
              },
              email: {
                type: "string",
                example: "exemplo@gmail.com"
              },
              phone: {
                type: "string",
                example: "+00 00 00000000"
              },
              type: {
                type: "string",
                example: "USER"
              },
              statusAccount: {
                type: "boolean"
              }
            }
          }
        }
      }
    },
    {
      name: "id",
      in: "query",
      required: true,
      description: "Enter the ID collaborator",
      type: "string"
    }
  ],
  responses: {
    "200": {
      description: "OK",
      schema: {
        type: "object",
        properties: {
          id: {
            type: "string"
          },
          name: {
            type: "string"
          },
          email: {
            type: "string"
          },
          phone: {
            type: "string"
          },
          statusAccount: {
            type: "boolean"
          },
          type: {
            type: "string"
          },
          updatedAt: {
            type: "string"
          }
        }
      }
    },
    "400": {
      description: "Insufficient data or data not provided",
      error: "Bad Request"
    },
    "401": {
      description: "Token was not provided",
      error: "Unauthorized"
    },
    "422": {
      description: "This token is not valid",
      error: "Unprocessable Entity"
    },
    "403": {
      description: "Collaborator not authorized for this operation",
      error: "Forbidden"
    },
    "500": {
      description:
        "Something unexpected happened during processing on the server",
      error: "Internal Server Error"
    }
  }
}
