"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.default = PostAnimals;
const operation_1 = require("../../middlewares/operation");
const schemas_1 = require("../../schemas");
const create_1 = require("../../services/prisma/animals/create");
const fetch_1 = require("../../services/prisma/homes/fetch");
const fetch_2 = require("../../services/prisma/typesAnimals/fetch");
const statusCode_1 = require("../../utils/statusCode");
async function PostAnimals(server) {
    server.post("/animals", {
        preHandler: operation_1.OperationMiddleware,
        schema: schemas_1.Schemas.animals.post
    }, async (request, reply) => {
        const { name, description, castrated, race, sex, typeAnimalId, dateExit, homeId } = request.body;
        if (!homeId) {
            return reply.status(statusCode_1.statusCode.badRequest.status).send({
                error: statusCode_1.statusCode.badRequest.error,
                description: "Home ID is required"
            });
        }
        try {
            const hasHome = !!(await (0, fetch_1.fetchHome)(homeId));
            if (!hasHome) {
                return reply.status(statusCode_1.statusCode.notFound.status).send({
                    error: statusCode_1.statusCode.notFound.error,
                    description: "We were unable to locate the home"
                });
            }
            const hasTypeAnimal = !!(await (0, fetch_2.fetchTypeAnimal)(typeAnimalId));
            if (!hasTypeAnimal) {
                return reply.status(statusCode_1.statusCode.notFound.status).send({
                    error: statusCode_1.statusCode.notFound.error,
                    description: "We were unable to locate the type of animal"
                });
            }
            const animal = {
                homeId,
                name,
                description,
                castrated,
                race,
                sex,
                typeAnimalId,
                dateExit
            };
            const data = await (0, create_1.createAnimal)(animal);
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
