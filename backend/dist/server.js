"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const cors_1 = __importDefault(require("@fastify/cors"));
const swagger_1 = __importDefault(require("@fastify/swagger"));
const swagger_ui_1 = __importDefault(require("@fastify/swagger-ui"));
const fastify_1 = __importDefault(require("fastify"));
const swagger_2 = require("./docs/swagger");
const swaggerUI_1 = require("./docs/swaggerUI");
const routes_1 = __importDefault(require("./routes"));
const server = (0, fastify_1.default)({ logger: true });
(0, routes_1.default)(server);
server.register(cors_1.default, {
    origin: "*",
    methods: ["GET", "PUT", "PATCH", "POST", "DELETE"],
    allowedHeaders: ["Content-Type", "authorization"],
    credentials: true
});
server.register(swagger_1.default, () => (0, swagger_2.SwaggerDocConfig)());
server.register(swagger_ui_1.default, () => (0, swaggerUI_1.SwaggerUIDocConfig)());
server.listen({ port: 7001, host: "0.0.0.0" }, err => {
    server.swagger();
    if (err) {
        console.error(err);
        process.exit(1);
    }
    console.log(`Server is running...`);
});
