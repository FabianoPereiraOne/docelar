"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.PathHomes = void 0;
const delete_1 = require("./delete");
const getAll_1 = require("./getAll");
const patch_1 = require("./patch");
const post_1 = require("./post");
exports.PathHomes = {
    get: getAll_1.GetAllConfigHomes,
    post: post_1.PostConfigHomes,
    delete: delete_1.DeleteConfigHomes,
    patch: patch_1.PatchConfigHomes
};
