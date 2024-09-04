"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.verify = verify;
exports.sign = sign;
const dotenv_1 = require("dotenv");
const jsonwebtoken_1 = __importDefault(require("jsonwebtoken"));
(0, dotenv_1.configDotenv)();
const secret = process.env.NEXT_PUBLIC_SECRET_KEY ?? "";
async function verify(authorization) {
    return jsonwebtoken_1.default.verify(authorization, secret);
}
async function sign(payload) {
    return jsonwebtoken_1.default.sign(payload, secret, { algorithm: "HS256", expiresIn: "1h" });
}
