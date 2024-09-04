"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.PathCollaborators = void 0;
const delete_1 = require("./delete");
const getAll_1 = require("./getAll");
const patch_1 = require("./patch");
const post_1 = require("./post");
exports.PathCollaborators = {
    get: getAll_1.GetAllConfigCollaborators,
    post: post_1.PostConfigCollaborators,
    delete: delete_1.DeleteConfigCollaborators,
    patch: patch_1.PatchConfigCollaborators
};
