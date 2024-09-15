"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const cors_1 = __importDefault(require("@fastify/cors"));
const multipart_1 = __importDefault(require("@fastify/multipart"));
const static_1 = __importDefault(require("@fastify/static"));
const swagger_1 = __importDefault(require("@fastify/swagger"));
const swagger_ui_1 = __importDefault(require("@fastify/swagger-ui"));
const fastify_1 = __importDefault(require("fastify"));
const path_1 = __importDefault(require("path"));
const swagger_2 = require("./docs/swagger");
const swaggerUI_1 = require("./docs/swaggerUI");
const routes_1 = __importDefault(require("./routes"));
const server = (0, fastify_1.default)();
server.register(multipart_1.default, {
    limits: {
        fileSize: 20 * 1024 * 1024
    }
});
server.register(static_1.default, {
    root: path_1.default.join(__dirname, "../public/uploads"),
    prefix: "/uploads/"
});
server.register(cors_1.default, {
    origin: "*",
    methods: ["GET", "POST", "PATCH", "DELETE"],
    allowedHeaders: ["Content-Type", "Authorization"]
});
(0, routes_1.default)(server);
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
