export const PostConfigProcedures = {
  tags: ["Procedures"],
  summary: "Create a procedure",
  description: "This route allows the admin to create a procedure",
  produces: ["application/json"],
  operationId: "createProcedures",
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
            example: "Vacina Gripe Canina"
          },
          description: {
            type: "string",
            example: "Protege contra o vírus da gripe canina"
          },
          dosage: {
            type: "string",
            example: "1 dose"
          }
        }
      }
    }
  ],
  responses: {
    "201": {
      description: "Created",
      schema: {
        $ref: "#/definitions/Procedure"
      }
    },
    "400": {
      description:
        "body must have required property \nbody/property must match pattern",
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
