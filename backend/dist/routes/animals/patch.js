"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.default = PatchAnimals;
const operation_1 = require("../../middlewares/operation");
const schemas_1 = require("../../schemas");
const fetch_1 = require("../../services/prisma/animals/fetch");
const update_1 = require("../../services/prisma/animals/update");
const fetch_2 = require("../../services/prisma/homes/fetch");
const fetch_3 = require("../../services/prisma/typesAnimals/fetch");
const statusCode_1 = require("../../utils/statusCode");
async function PatchAnimals(server) {
    server.patch("/animals", {
        preHandler: operation_1.OperationMiddleware,
        schema: schemas_1.Schemas.animals.patch
    }, async (request, reply) => {
        const { name, description, castrated, dateExit, homeId, linkPhoto, race, sex, status, typeAnimalId, id } = request.body;
        if (!id) {
            return reply.status(statusCode_1.statusCode.badRequest.status).send({
                error: statusCode_1.statusCode.badRequest.error,
                description: "Animal ID is required"
            });
        }
        try {
            const hasHome = homeId != undefined ? !!(await (0, fetch_2.fetchHome)(homeId)) : true;
            if (!hasHome) {
                return reply.status(statusCode_1.statusCode.notFound.status).send({
                    error: statusCode_1.statusCode.notFound.error,
                    description: "We were unable to locate the home"
                });
            }
            const hasTypeAnimal = typeAnimalId != undefined
                ? !!(await (0, fetch_3.fetchTypeAnimal)(typeAnimalId))
                : true;
            if (!hasTypeAnimal) {
                return reply.status(statusCode_1.statusCode.notFound.status).send({
                    error: statusCode_1.statusCode.notFound.error,
                    description: "We were unable to locate the type of animal"
                });
            }
            const hasAnimal = await (0, fetch_1.fetchAnimal)(id);
            if (!hasAnimal) {
                return reply.status(statusCode_1.statusCode.notFound.status).send({
                    error: statusCode_1.statusCode.notFound.error,
                    description: "We were unable to locate the animal"
                });
            }
            const animal = {
                id,
                homeId,
                name,
                description,
                castrated,
                race,
                sex,
                typeAnimalId,
                dateExit,
                linkPhoto,
                status
            };
            const data = await (0, update_1.updateAnimal)(animal);
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
