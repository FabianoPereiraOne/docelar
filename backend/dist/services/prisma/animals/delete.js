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
            linkPhoto: true,
            dateExit: true,
            status: true,
            createdAt: true,
            updatedAt: true,
            homeId: true,
            typeAnimal: {
                select: {
                    id: true,
                    type: true
                }
            },
            services: true
        }
    });
    return result;
};
exports.deleteAnimal = deleteAnimal;
