"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.default = PatchServices;
const useReturnValidID_1 = require("../../hooks/useReturnValidID");
const useVerifyEntity_1 = require("../../hooks/useVerifyEntity");
const operation_1 = require("../../middlewares/operation");
const schemas_1 = require("../../schemas");
const fetch_1 = require("../../services/prisma/animals/fetch");
const fetch_2 = require("../../services/prisma/doctors/fetch");
const fetch_3 = require("../../services/prisma/procedures/fetch");
const fetch_4 = require("../../services/prisma/services/fetch");
const update_1 = require("../../services/prisma/services/update");
const statusCode_1 = require("../../utils/statusCode");
async function PatchServices(server) {
    server.patch("/services", {
        preHandler: operation_1.OperationMiddleware,
        schema: schemas_1.Schemas.services.patch
    }, async (request, reply) => {
        const { description, status, animalId, doctors, procedures, id } = request.body;
        if (!id) {
            return reply.status(statusCode_1.statusCode.badRequest.status).send({
                error: statusCode_1.statusCode.badRequest.error,
                description: "Service ID is required"
            });
        }
        try {
            const services = await (0, fetch_4.fetchService)(id);
            const hasService = !!services;
            if (!hasService) {
                return reply.status(statusCode_1.statusCode.notFound.status).send({
                    error: statusCode_1.statusCode.notFound.error,
                    description: "We were unable to locate the service"
                });
            }
            const hasAnimal = animalId ? !!(await (0, fetch_1.fetchAnimal)(animalId)) : true;
            if (!hasAnimal) {
                return reply.status(statusCode_1.statusCode.notFound.status).send({
                    error: statusCode_1.statusCode.notFound.error,
                    description: "We were unable to locate the animal"
                });
            }
            const listDoctors = doctors
                ? await (0, useVerifyEntity_1.useGetArrayEntity)({
                    listEntity: doctors,
                    functionGet: fetch_2.fetchDoctor
                })
                : [];
            const listDoctorsValid = doctors ? (0, useReturnValidID_1.useReturnValidID)(listDoctors) : [];
            const hasDoctors = doctors ? listDoctorsValid.length > 0 : true;
            if (!hasDoctors) {
                return reply.status(statusCode_1.statusCode.conflict.status).send({
                    error: statusCode_1.statusCode.conflict.error,
                    description: "Invalid doctor(s)"
                });
            }
            const listProcedures = procedures
                ? await (0, useVerifyEntity_1.useGetArrayEntity)({
                    listEntity: procedures,
                    functionGet: fetch_3.fetchProcedure
                })
                : [];
            const listProceduresValid = procedures
                ? (0, useReturnValidID_1.useReturnValidID)(listProcedures)
                : [];
            const hasProcedures = procedures ? listProceduresValid.length > 0 : true;
            if (!hasProcedures) {
                return reply.status(statusCode_1.statusCode.conflict.status).send({
                    error: statusCode_1.statusCode.conflict.error,
                    description: "Invalid procedure(s)"
                });
            }
            const service = {
                id,
                description,
                animalId,
                listDoctors: listDoctorsValid,
                listProcedures: listProceduresValid,
                listDoctorsOld: services.doctors.map(doctor => doctor.id),
                listProceduresOld: services.procedures.map(procedure => procedure.id),
                status
            };
            const data = await (0, update_1.updateService)(service);
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
