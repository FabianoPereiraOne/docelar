"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.createService = void 0;
const prisma_client_1 = require("../../../database/prisma-client");
const createService = async ({ description, animalId, listDoctors, listProcedures }) => {
    const result = await prisma_client_1.prisma.service.create({
        data: {
            description,
            animal: {
                connect: {
                    id: animalId
                }
            },
            doctors: {
                connect: listDoctors
            },
            procedures: {
                connect: listProcedures
            }
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
exports.createService = createService;
