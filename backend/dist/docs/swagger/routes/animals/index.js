"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.PathAnimals = void 0;
const delete_1 = require("./delete");
const getAll_1 = require("./getAll");
const patch_1 = require("./patch");
const post_1 = require("./post");
exports.PathAnimals = {
    get: getAll_1.GetAllConfigAnimals,
    post: post_1.PostConfigAnimals,
    delete: delete_1.DeleteConfigAnimals,
    patch: patch_1.PatchConfigAnimals
};
