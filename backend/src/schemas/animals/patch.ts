export const patchProperties = {
  body: {
    type: "object",
    properties: {
      name: {
        type: "string",
        pattern: "\\S"
      },
      description: {
        type: "string",
        pattern: "\\S"
      },
      sex: {
        type: "string",
        pattern: "\\S"
      },
      castrated: {
        type: "boolean"
      },
      race: {
        type: "string",
        pattern: "\\S"
      },
      typeAnimalId: {
        type: "number"
      },
      linkPhoto: {
        type: "string",
        pattern: "\\S"
      },
      dateExit: {
        type: "string",
        pattern: "\\S"
      },
      status: {
        type: "boolean"
      },
      homeId: {
        type: "string",
        pattern: "\\S"
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
