"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.PathDocuments = void 0;
const delete_1 = require("./delete");
const getAll_1 = require("./getAll");
const patch_1 = require("./patch");
const post_1 = require("./post");
exports.PathDocuments = {
    get: getAll_1.GetAllConfigDocuments,
    post: post_1.PostConfigDocuments,
    delete: delete_1.DeleteConfigDocuments,
    patch: patch_1.PatchConfigDocuments
};
