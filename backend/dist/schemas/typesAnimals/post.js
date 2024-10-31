"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.postProperties = void 0;
exports.postProperties = {
    body: {
        type: "object",
        required: ["type"],
        properties: {
            type: {
                type: "string",
                pattern: "\\S"
            }
        }
    }
};
