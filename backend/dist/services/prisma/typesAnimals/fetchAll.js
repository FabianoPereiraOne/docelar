"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.fetchAllTypesAnimals = void 0;
const prisma_client_1 = require("../../../database/prisma-client");
const fetchAllTypesAnimals = async () => {
    const result = await prisma_client_1.prisma.typeAnimal.findMany({
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
                    linkPhoto: true,
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
exports.fetchAllTypesAnimals = fetchAllTypesAnimals;
