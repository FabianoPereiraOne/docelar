export const postProperties = {
  body: {
    type: "object",
    required: ["description", "procedures", "doctors"],
    properties: {
      description: {
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
    required: ["animalId"],
    properties: {
      animalId: { type: "string" }
    }
  }
}
