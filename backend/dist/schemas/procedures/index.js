"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.schemaProcedures = void 0;
const delete_1 = require("./delete");
const get_1 = require("./get");
const patch_1 = require("./patch");
const post_1 = require("./post");
exports.schemaProcedures = {
    get: get_1.getProperties,
    post: post_1.postProperties,
    patch: patch_1.patchProperties,
    delete: delete_1.deleteProperties
};
