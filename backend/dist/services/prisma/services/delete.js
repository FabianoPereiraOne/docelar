"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.deleteService = void 0;
const prisma_client_1 = require("../../../database/prisma-client");
const deleteService = async (id) => {
    const result = await prisma_client_1.prisma.service.delete({
        where: {
            id
        },
        select: {
            id: true,
            description: true,
            status: true,
            createdAt: true,
            updatedAt: true,
            animal: true,
            doctors: true,
            procedures: true,
            documents: true
        }
    });
    return result;
};
exports.deleteService = deleteService;
