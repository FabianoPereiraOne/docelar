"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.patchProperties = void 0;
exports.patchProperties = {
    body: {
        type: "object",
        properties: {
            id: { type: "number" },
            name: {
                type: "string",
                pattern: "\\S"
            },
            description: {
                type: "string",
                pattern: "\\S"
            },
            dosage: {
                type: "string",
                pattern: "\\S"
            }
        }
    }
};
