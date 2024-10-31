"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.default = Doctors;
const delete_1 = __importDefault(require("./delete"));
const get_1 = __importDefault(require("./get"));
const getAll_1 = __importDefault(require("./getAll"));
const patch_1 = __importDefault(require("./patch"));
const post_1 = __importDefault(require("./post"));
async function Doctors(server) {
    server.register(post_1.default);
    server.register(patch_1.default);
    server.register(delete_1.default);
    server.register(get_1.default);
    server.register(getAll_1.default);
}
