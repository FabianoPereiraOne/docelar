"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.deleteTypeAnimal = void 0;
const prisma_client_1 = require("../../../database/prisma-client");
const deleteTypeAnimal = async (id) => {
    const result = await prisma_client_1.prisma.typeAnimal.delete({
        where: {
            id
        },
        select: {
            id: true,
            type: true,
            createdAt: true,
            updatedAt: true,
            animals: {
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
                    homeId: true
                }
            }
        }
    });
    return result;
};
exports.deleteTypeAnimal = deleteTypeAnimal;
