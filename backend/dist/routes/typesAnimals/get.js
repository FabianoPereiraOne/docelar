"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.default = GetTypesAnimals;
const operation_1 = require("../../middlewares/operation");
const schemas_1 = require("../../schemas");
const fetch_1 = require("../../services/prisma/typesAnimals/fetch");
const statusCode_1 = require("../../utils/statusCode");
async function GetTypesAnimals(server) {
    server.get("/types-animals/:id", {
        preHandler: operation_1.OperationMiddleware,
        schema: schemas_1.Schemas.typesAnimals.get
    }, async (request, reply) => {
        const { id } = request.params;
        try {
            const data = await (0, fetch_1.fetchTypeAnimal)(id);
            const hasAnimal = !!data;
            if (!hasAnimal) {
                return reply.status(statusCode_1.statusCode.notFound.status).send({
                    error: statusCode_1.statusCode.notFound.error,
                    description: "We were unable to locate the type of animal"
                });
            }
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
