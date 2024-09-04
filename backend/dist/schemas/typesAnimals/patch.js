"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.patchProperties = void 0;
exports.patchProperties = {
    body: {
        type: "object",
        properties: {
            id: { type: "number" },
            type: {
                type: "string",
                pattern: "\\S"
            }
        }
    }
};
