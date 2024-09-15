export const postProperties = {
  body: {
    type: "object",
    required: ["description", "procedures"],
    properties: {
      animalId: { type: "string", pattern: "\\S" },
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
  }
}
