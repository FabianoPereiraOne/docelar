"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.createTypeAnimal = void 0;
const prisma_client_1 = require("../../../database/prisma-client");
const createTypeAnimal = async (type) => {
    const result = await prisma_client_1.prisma.typeAnimal.create({
        data: {
            type
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
exports.createTypeAnimal = createTypeAnimal;
