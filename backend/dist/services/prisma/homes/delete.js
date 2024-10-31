"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.deleteHome = void 0;
const prisma_client_1 = require("../../../database/prisma-client");
const deleteHome = async (id) => {
    const result = await prisma_client_1.prisma.home.delete({
        where: {
            id
        },
        select: {
            id: true,
            cep: true,
            state: true,
            city: true,
            district: true,
            address: true,
            number: true,
            status: true,
            createdAt: true,
            updatedAt: true,
            collaboratorId: true,
            animals: true
        }
    });
    return result;
};
exports.deleteHome = deleteHome;
