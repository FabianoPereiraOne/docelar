export const GetConfigCollaborators = {
  tags: ["Collaborators"],
  summary: "Find collaborator",
  description: "This route allows you to search for a collaborator by ID",
  produces: ["application/json"],
  operationId: "getCollaboratorByID",
  security: [
    {
      authorization: []
    }
  ],
  parameters: [
    {
      name: "id",
      in: "path",
      description: "ID Collaborator",
      required: true,
      type: "string"
    }
  ],
  responses: {
    "200": {
      description: "OK",
      schema: {
        $ref: "#/definitions/Collaborator"
      }
    },
    "400": {
      description: "params/id must NOT have fewer than 10 characters",
      error: "Bad Request"
    },
    "404": {
      description: "We were unable to locate the collaborator",
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
