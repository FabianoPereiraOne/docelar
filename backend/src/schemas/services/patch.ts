export const patchProperties = {
  body: {
    type: "object",
    properties: {
      description: {
        type: "string",
        pattern: "\\S"
      },
      status: {
        type: "boolean"
      },
      animalId: {
        type: "string",
        pattern: "\\S"
      },
      procedures: {
        type: "array",
        items: {
          type: "object",
          required: ["id"],
          properties: {
            id: {
              type: "number"
            }
          }
        },
        minItems: 1
      },
      doctors: {
        type: "array",
        items: {
          type: "object",
          required: ["id"],
          properties: {
            id: {
              type: "string",
              pattern: "\\S"
            }
          }
        },
        minItems: 1
      }
    }
  },
  querystring: {
    type: "object",
    required: ["id"],
    properties: {
      id: { type: "string" }
    }
  }
}
