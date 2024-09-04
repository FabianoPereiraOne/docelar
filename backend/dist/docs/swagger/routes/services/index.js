"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.PathServices = void 0;
const delete_1 = require("./delete");
const getAll_1 = require("./getAll");
const patch_1 = require("./patch");
const post_1 = require("./post");
exports.PathServices = {
    get: getAll_1.GetAllConfigServices,
    post: post_1.PostConfigServices,
    delete: delete_1.DeleteConfigServices,
    patch: patch_1.PatchConfigServices
};
