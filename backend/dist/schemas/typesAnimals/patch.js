"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.patchProperties = void 0;
exports.patchProperties = {
    body: {
        type: "object",
        required: ["id"],
        properties: {
            id: { type: "number" },
            type: {
                type: "string",
                pattern: "\\S"
            }
        }
    }
};
