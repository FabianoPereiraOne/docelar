export const patchProperties = {
  body: {
    type: "object",
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
        type: "number"
      },
      linkPhoto: {
        type: "string"
      },
      dateExit: {
        type: "string"
      },
      status: {
        type: "boolean"
      },
      homeId: {
        type: "string"
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
