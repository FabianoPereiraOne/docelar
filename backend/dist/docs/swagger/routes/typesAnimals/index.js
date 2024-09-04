"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.PathTypesAnimals = void 0;
const delete_1 = require("./delete");
const getAll_1 = require("./getAll");
const patch_1 = require("./patch");
const post_1 = require("./post");
exports.PathTypesAnimals = {
    get: getAll_1.GetAllConfigTypesAnimals,
    post: post_1.PostConfigTypesAnimals,
    delete: delete_1.DeleteConfigTypesAnimals,
    patch: patch_1.PatchConfigTypesAnimals
};
