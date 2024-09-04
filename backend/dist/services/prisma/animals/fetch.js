"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.fetchAnimal = void 0;
const prisma_client_1 = require("../../../database/prisma-client");
const fetchAnimal = async (id) => {
    const result = await prisma_client_1.prisma.animal.findFirst({
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
exports.fetchAnimal = fetchAnimal;
