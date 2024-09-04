"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.default = PostServices;
const useReturnValidID_1 = require("../../hooks/useReturnValidID");
const useVerifyEntity_1 = require("../../hooks/useVerifyEntity");
const operation_1 = require("../../middlewares/operation");
const schemas_1 = require("../../schemas");
const fetch_1 = require("../../services/prisma/animals/fetch");
const fetch_2 = require("../../services/prisma/doctors/fetch");
const fetch_3 = require("../../services/prisma/procedures/fetch");
const create_1 = require("../../services/prisma/services/create");
const statusCode_1 = require("../../utils/statusCode");
async function PostServices(server) {
    server.post("/services", {
        preHandler: operation_1.OperationMiddleware,
        schema: schemas_1.Schemas.services.post
    }, async (request, reply) => {
        const { description, doctors, procedures, animalId } = request.body;
        if (!animalId) {
            return reply.status(statusCode_1.statusCode.badRequest.status).send({
                error: statusCode_1.statusCode.badRequest.error,
                description: "Animal ID is required"
            });
        }
        try {
            const hasAnimal = !!(await (0, fetch_1.fetchAnimal)(animalId));
            if (!hasAnimal) {
                return reply.status(statusCode_1.statusCode.notFound.status).send({
                    error: statusCode_1.statusCode.notFound.error,
                    description: "We were unable to locate the animal"
                });
            }
            const listDoctors = await (0, useVerifyEntity_1.useGetArrayEntity)({
                listEntity: doctors,
                functionGet: fetch_2.fetchDoctor
            });
            const listDoctorsValid = (0, useReturnValidID_1.useReturnValidID)(listDoctors);
            const hasDoctors = listDoctorsValid.length > 0;
            if (!hasDoctors) {
                return reply.status(statusCode_1.statusCode.conflict.status).send({
                    error: statusCode_1.statusCode.conflict.error,
                    description: "Invalid doctor(s)"
                });
            }
            const listProcedures = await (0, useVerifyEntity_1.useGetArrayEntity)({
                listEntity: procedures,
                functionGet: fetch_3.fetchProcedure
            });
            const listProceduresValid = (0, useReturnValidID_1.useReturnValidID)(listProcedures);
            const hasProcedures = listProceduresValid.length > 0;
            if (!hasProcedures) {
                return reply.status(statusCode_1.statusCode.conflict.status).send({
                    error: statusCode_1.statusCode.conflict.error,
                    description: "Invalid procedure(s)"
                });
            }
            const service = {
                description,
                animalId,
                listDoctors: listDoctorsValid,
                listProcedures: listProceduresValid
            };
            const data = await (0, create_1.createService)(service);
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
