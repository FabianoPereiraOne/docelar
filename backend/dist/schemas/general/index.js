"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.schemaGeneral = void 0;
const delete_1 = require("./delete");
const get_1 = require("./get");
exports.schemaGeneral = {
    get: get_1.getProperties,
    delete: delete_1.deleteProperties
};
