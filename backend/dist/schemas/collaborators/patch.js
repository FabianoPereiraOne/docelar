"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.patchProperties = void 0;
exports.patchProperties = {
    headers: {
        type: "object",
        properties: {
            password: { type: "string" }
        }
    },
    body: {
        type: "object",
        properties: {
            id: { type: "string", pattern: "\\S" },
            name: {
                type: "string",
                pattern: "\\S"
            },
            phone: {
                type: "string",
                pattern: "\\S"
            },
            statusAccount: {
                type: "boolean"
            },
            type: {
                type: "string",
                pattern: "\\S"
            }
        }
    }
};
