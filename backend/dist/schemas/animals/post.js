"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.postProperties = void 0;
exports.postProperties = {
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
            homeId: { type: "string", pattern: "\\S" },
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
    }
};
