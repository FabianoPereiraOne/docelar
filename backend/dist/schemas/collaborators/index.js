"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.schemaCollaborators = void 0;
const patch_1 = require("./patch");
const post_1 = require("./post");
exports.schemaCollaborators = {
    post: post_1.postProperties,
    patch: patch_1.patchProperties
};
