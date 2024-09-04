"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.postProperties = void 0;
exports.postProperties = {
    body: {
        type: "object",
        required: ["cep", "state", "city", "address", "number"],
        properties: {
            collaboratorId: { type: "string", pattern: "\\S" },
            cep: {
                type: "string",
                pattern: "\\S"
            },
            state: {
                type: "string",
                pattern: "\\S"
            },
            city: {
                type: "string",
                pattern: "\\S"
            },
            address: {
                type: "string",
                pattern: "\\S"
            },
            number: {
                type: "string",
                pattern: "\\S"
            }
        }
    }
};
