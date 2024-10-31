"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.PathDoctors = void 0;
const delete_1 = require("./delete");
const getAll_1 = require("./getAll");
const patch_1 = require("./patch");
const post_1 = require("./post");
exports.PathDoctors = {
    get: getAll_1.GetAllConfigDoctors,
    post: post_1.PostConfigDoctors,
    delete: delete_1.DeleteConfigDoctors,
    patch: patch_1.PatchConfigDoctors
};
