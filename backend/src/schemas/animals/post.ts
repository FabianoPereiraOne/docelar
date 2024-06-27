export const postProperties = {
  body: {
    type: "object",
    required: [
      "name",
      "description",
      "sex",
      "castrated",
      "race",
      "typeAnimalId"
    ],
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
      }
    }
  },
  querystring: {
    type: "object",
    required: ["homeId"],
    properties: {
      homeId: { type: "string" }
    }
  }
}
