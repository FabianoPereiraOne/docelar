"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.default = PatchTypesAnimals;
const operation_1 = require("../../middlewares/operation");
const schemas_1 = require("../../schemas");
const fetch_1 = require("../../services/prisma/typesAnimals/fetch");
const update_1 = require("../../services/prisma/typesAnimals/update");
const statusCode_1 = require("../../utils/statusCode");
async function PatchTypesAnimals(server) {
    server.patch("/types-animals", {
        preHandler: operation_1.OperationMiddleware,
        schema: schemas_1.Schemas.typesAnimals.patch
    }, async (request, reply) => {
        const { type, id } = request.body;
        if (!id) {
            return reply.status(statusCode_1.statusCode.badRequest.status).send({
                error: statusCode_1.statusCode.badRequest.error,
                description: "Animal Type ID is required"
            });
        }
        try {
            const hasTypeAnimal = await (0, fetch_1.fetchTypeAnimal)(id);
            if (!hasTypeAnimal) {
                return reply.status(statusCode_1.statusCode.notFound.status).send({
                    error: statusCode_1.statusCode.notFound.error,
                    description: "We were unable to locate the type of animal"
                });
            }
            const typeAnimal = { id: Number(id), type };
            const data = await (0, update_1.updateTypeAnimal)(typeAnimal);
            return reply.status(statusCode_1.statusCode.success.status).send({
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
