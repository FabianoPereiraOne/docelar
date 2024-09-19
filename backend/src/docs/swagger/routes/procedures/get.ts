export const GetConfigProcedures = {
  tags: ["Procedures"],
  summary: "Search for a procedure",
  description: "This route allows you to search for a procedure by ID",
  produces: ["application/json"],
  operationId: "getProcedureByID",
  security: [
    {
      authorization: []
    }
  ],
  parameters: [
    {
      name: "id",
      in: "path",
      description: "Procedure ID",
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
      description: "params/id must be number",
      error: "Bad Request"
    },
    "404": {
      description: "We were unable to locate the procedure",
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
