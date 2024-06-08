export const GetAllConfigCollaborator = {
  tags: ["Collaborators"],
  summary: "Find all collaborators",
  description: "This route allows you to search for all collaborators",
  produces: ["application/json"],
  operationId: "getAllCollaborators",
  security: [
    {
      authorization: []
    }
  ],
  responses: {
    "200": {
      description: "OK",
      schema: {
        items: {
          $ref: "#/definitions/Collaborator"
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
