"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.patchProperties = void 0;
exports.patchProperties = {
    body: {
        type: "object",
        properties: {
            id: { type: "string", pattern: "\\S" },
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
            district: {
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
            },
            status: {
                type: "boolean"
            }
        }
    }
};