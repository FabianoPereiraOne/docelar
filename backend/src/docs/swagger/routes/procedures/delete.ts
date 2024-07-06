export const DeleteConfigProcedures = {
  tags: ["Procedures"],
  summary: "Delete a procedure",
  description: "This route allows the admin to delete a procedure",
  produces: ["application/json"],
  operationId: "deleteProcedure",
  security: [
    {
      authorization: []
    }
  ],
  parameters: [
    {
      name: "id",
      in: "query",
      description: "Enter the ID a procedure",
      required: true,
      type: "number"
    }
  ],
  responses: {
    "200": {
      description: "OK",
      schema: {
        $ref: "#/definitions/Procedure"
      }
    },
    "400": {
      description: "querystring must have required property 'id'",
      error: "Bad Request"
    },
    "404": {
      description: "We were unable to locate the procedure",
      error: "Not Found"
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
    "500": {
      description:
        "Something unexpected happened during processing on the server",
      error: "Internal Server Error"
    }
  }
}
