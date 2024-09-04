"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.PathProcedure = void 0;
const delete_1 = require("./delete");
const getAll_1 = require("./getAll");
const patch_1 = require("./patch");
const post_1 = require("./post");
exports.PathProcedure = {
    get: getAll_1.GetAllConfigProcedures,
    post: post_1.PostConfigProcedures,
    delete: delete_1.DeleteConfigProcedures,
    patch: patch_1.PatchConfigProcedures
};
