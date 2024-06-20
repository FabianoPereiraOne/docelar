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
        type: "string"
      },
      description: {
        type: "string"
      },
      sex: {
        type: "string"
      },
      castrated: {
        type: "boolean"
      },
      race: {
        type: "string"
      },
      typeAnimalId: {
        type: "string"
      },
      linkPhoto: {
        type: "string"
      },
      dateExit: {
        type: "string"
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
