"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.patchProperties = void 0;
exports.patchProperties = {
    body: {
        type: "object",
        properties: {
            id: { type: "string", pattern: "\\S" },
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
            documents: {
                type: "array",
                items: {
                    type: "object",
                    required: ["id"],
                    properties: {
                        id: {
                            type: "number"
                        },
                        animalId: {
                            type: "string"
                        },
                        serviceId: {
                            type: "string"
                        },
                        key: {
                            type: "string"
                        }
                    }
                }
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
    }
};
