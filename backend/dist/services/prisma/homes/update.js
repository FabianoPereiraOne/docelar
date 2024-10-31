"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.updateHome = void 0;
const prisma_client_1 = require("../../../database/prisma-client");
const updateHome = async ({ id, address, cep, city, number, district, state, status }) => {
    const result = await prisma_client_1.prisma.home.update({
        data: {
            address,
            cep,
            city,
            district,
            number,
            state,
            status
        },
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
exports.updateHome = updateHome;
