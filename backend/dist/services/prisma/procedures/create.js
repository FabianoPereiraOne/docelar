"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.createProcedure = void 0;
const prisma_client_1 = require("../../../database/prisma-client");
const createProcedure = async ({ name, description, dosage }) => {
    const result = await prisma_client_1.prisma.procedure.create({
        data: {
            name,
            description,
            dosage
        },
        select: {
            id: true,
            name: true,
            description: true,
            dosage: true,
            createdAt: true,
            updatedAt: true,
            services: true
        }
    });
    return result;
};
exports.createProcedure = createProcedure;
