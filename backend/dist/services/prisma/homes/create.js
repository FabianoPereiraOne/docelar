"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.createHome = void 0;
const prisma_client_1 = require("../../../database/prisma-client");
const createHome = async ({ address, cep, city, collaboratorId, number, district, state }) => {
    const result = await prisma_client_1.prisma.home.create({
        data: {
            address,
            cep,
            city,
            district,
            number,
            state,
            collaborator: {
                connect: {
                    id: collaboratorId
                }
            }
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
exports.createHome = createHome;
