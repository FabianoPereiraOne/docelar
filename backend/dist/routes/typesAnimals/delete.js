"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.default = DeleteTypesAnimals;
const operation_1 = require("../../middlewares/operation");
const schemas_1 = require("../../schemas");
const delete_1 = require("../../services/prisma/typesAnimals/delete");
const fetch_1 = require("../../services/prisma/typesAnimals/fetch");
const statusCode_1 = require("../../utils/statusCode");
async function DeleteTypesAnimals(server) {
    server.delete("/types-animals", {
        preHandler: operation_1.OperationMiddleware,
        schema: schemas_1.Schemas.typesAnimals.delete
    }, async (request, reply) => {
        const { id } = request.query;
        try {
            const typeAnimal = await (0, fetch_1.fetchTypeAnimal)(id);
            const hasTypeAnimal = !!typeAnimal;
            if (!hasTypeAnimal) {
                return reply.status(statusCode_1.statusCode.notFound.status).send({
                    error: statusCode_1.statusCode.notFound.error,
                    description: "We were unable to locate the type of animal"
                });
            }
            const data = await (0, delete_1.deleteTypeAnimal)(id);
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
