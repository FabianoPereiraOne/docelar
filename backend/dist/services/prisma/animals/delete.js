"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.deleteAnimal = void 0;
const prisma_client_1 = require("../../../database/prisma-client");
const deleteAnimal = async (id) => {
    const result = await prisma_client_1.prisma.animal.delete({
        where: {
            id
        },
        select: {
            id: true,
            name: true,
            description: true,
            sex: true,
            castrated: true,
            race: true,
            dateExit: true,
            status: true,
            createdAt: true,
            updatedAt: true,
            home: {
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
                    collaboratorId: true
                }
            },
            typeAnimal: {
                select: {
                    id: true,
                    type: true
                }
            },
            services: true,
            documents: true
        }
    });
    return result;
};
exports.deleteAnimal = deleteAnimal;
