export const PostConfigCollaborator = {
  tags: ["Collaborator"],
  summary: "Create collaborator",
  description: "This route allows the admin to create a collaborator",
  produces: ["application/json"],
  operationId: "createCollaborator",
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
          collaborator: {
            $ref: "#/definitions/Collaborator"
          }
        }
      }
    },
    {
      name: "password",
      in: "header",
      required: true,
      description: "Enter the password for registration",
      type: "string"
    }
  ],
  responses: {
    "201": {
      description: "Created",
      schema: {
        $ref: "#/definitions/Collaborator"
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
