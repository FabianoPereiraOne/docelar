export const PostConfigSign = {
  tags: ["Sign"],
  summary: "Sign-in collaborator",
  description: "This route allows the collaborator to log into the system",
  produces: ["application/json"],
  operationId: "signCollaborator",
  parameters: [
    {
      name: "body",
      in: "body",
      required: true,
      description: "Enter the email for sign-in",
      schema: {
        type: "object",
        properties: {
          email: {
            type: "string",
            example: "exemplo@gmail.com"
          }
        }
      }
    },
    {
      name: "password",
      in: "header",
      required: true,
      description: "Enter the password for sign-in",
      type: "string"
    }
  ],
  responses: {
    "200": {
      description: "Success",
      schema: {
        type: "object",
        properties: {
          authorization: {
            type: "string"
          }
        }
      }
    },
    "401": {
      description: "The password provided is invalid",
      error: "Unauthorized"
    },
    "404": {
      description: "We were unable to locate the collaborator",
      error: "Not found"
    },
    "400": {
      description: "headers or body must have required property",
      error: "Bad Request"
    },
    "500": {
      description:
        "Something unexpected happened during processing on the server",
      error: "Internal Server Error"
    }
  }
}
