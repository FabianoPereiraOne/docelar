"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.default = Upload;
const delete_1 = __importDefault(require("./delete"));
const post_1 = __importDefault(require("./post"));
async function Upload(server) {
    server.register(post_1.default);
    server.register(delete_1.default);
}
