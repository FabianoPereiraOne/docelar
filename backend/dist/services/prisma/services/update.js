"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.updateService = void 0;
const prisma_client_1 = require("../../../database/prisma-client");
const updateService = async ({ id, description, animalId, status, listDoctors, listProcedures, listDoctorsOld, listProceduresOld }) => {
    const animal = animalId
        ? {
            connect: {
                id: animalId
            }
        }
        : undefined;
    const doctors = listDoctors.length > 0
        ? {
            disconnect: listDoctorsOld.map(doctorID => ({
                id: doctorID
            })),
            connect: listDoctors
        }
        : undefined;
    const procedures = listProcedures.length > 0
        ? {
            disconnect: listProceduresOld.map(procedureID => ({
                id: procedureID
            })),
            connect: listProcedures
        }
        : undefined;
    const result = await prisma_client_1.prisma.service.update({
        where: {
            id
        },
        data: {
            description,
            status,
            animal,
            doctors,
            procedures
        },
        select: {
            id: true,
            description: true,
            status: true,
            createdAt: true,
            updatedAt: true,
            animal: true,
            doctors: true,
            procedures: true
        }
    });
    return result;
};
exports.updateService = updateService;
