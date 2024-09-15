export const DeleteConfigUpload = {
  tags: ["Upload"],
  summary: "Delete file",
  description: "This route allows the admin to file",
  produces: ["application/json"],
  operationId: "deleteFileByKey",
  security: [
    {
      authorization: []
    }
  ],
  parameters: [
    {
      name: "key",
      in: "query",
      description: "Enter the Key File",
      required: true,
      type: "string"
    }
  ],
  responses: {
    "200": {
      description: "OK",
      schema: {
        type: "object",
        properties: {
          success: {
            type: "string",
            example: "File deleted successfully."
          }
        }
      }
    },
    "400": {
      description: "File key is required.",
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
    "500": {
      description:
        "Something unexpected happened during processing on the server",
      error: "Internal Server Error"
    }
  }
}
