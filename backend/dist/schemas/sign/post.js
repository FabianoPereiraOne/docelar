"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.postProperties = void 0;
exports.postProperties = {
    headers: {
        type: "object",
        required: ["password"],
        properties: {
            password: { type: "string" }
        }
    },
    body: {
        type: "object",
        required: ["email"],
        properties: {
            email: {
                type: "string",
                pattern: "\\S"
            }
        }
    }
};
