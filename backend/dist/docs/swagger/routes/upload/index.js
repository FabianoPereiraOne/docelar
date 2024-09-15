"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.PathUpload = void 0;
const delete_1 = require("./delete");
const post_1 = require("./post");
exports.PathUpload = {
    post: post_1.PostConfigUpload,
    delete: delete_1.DeleteConfigUpload
};
