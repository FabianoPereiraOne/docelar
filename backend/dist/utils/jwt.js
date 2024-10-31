"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.verify = verify;
exports.sign = sign;
const dotenv_1 = require("dotenv");
const jsonwebtoken_1 = __importDefault(require("jsonwebtoken"));
const statusCode_1 = require("./statusCode");
(0, dotenv_1.configDotenv)();
const secret = process.env.NEXT_PUBLIC_SECRET_KEY ?? "";
async function verify(authorization, reply) {
    try {
        const decoded = jsonwebtoken_1.default.verify(authorization, secret);
        return decoded;
    }
    catch (error) {
        if (error?.name === "TokenExpiredError") {
            return reply.status(statusCode_1.statusCode.tokenExpired.status).send({
                error: statusCode_1.statusCode.tokenExpired.error,
                description: "The token has expired. Please refresh your token"
            });
        }
        return reply.status(statusCode_1.statusCode.serverError.status).send({
            error: statusCode_1.statusCode.serverError.error,
            description: "Something unexpected happened during processing on the server"
        });
    }
}
async function sign(payload) {
    return jsonwebtoken_1.default.sign(payload, secret, { algorithm: "HS256", expiresIn: "2h" });
}
