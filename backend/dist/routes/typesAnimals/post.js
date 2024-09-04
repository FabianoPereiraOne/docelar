"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.default = PostTypesAnimals;
const operation_1 = require("../../middlewares/operation");
const schemas_1 = require("../../schemas");
const create_1 = require("../../services/prisma/typesAnimals/create");
const statusCode_1 = require("../../utils/statusCode");
async function PostTypesAnimals(server) {
    server.post("/types-animals", {
        preHandler: operation_1.OperationMiddleware,
        schema: schemas_1.Schemas.typesAnimals.post
    }, async (request, reply) => {
        const { type } = request.body;
        try {
            const data = await (0, create_1.createTypeAnimal)(type);
            return reply.status(statusCode_1.statusCode.create.status).send({
                data
            });
        }
        catch (error) {
            return reply.status(statusCode_1.statusCode.serverError.status).send({
                error: statusCode_1.statusCode.serverError.error,
                description: "Something unexpected happened during processing on the server"
            });
        }
    });
}
