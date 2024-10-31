"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.postProperties = void 0;
exports.postProperties = {
    body: {
        type: "object",
        required: ["name", "description", "dosage"],
        properties: {
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
