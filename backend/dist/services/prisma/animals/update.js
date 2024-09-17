"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.updateAnimal = void 0;
const prisma_client_1 = require("../../../database/prisma-client");
const updateAnimal = async ({ id, castrated, dateExit, description, homeId, linkPhoto, name, race, sex, status, typeAnimalId }) => {
    const home = homeId
        ? {
            connect: {
                id: homeId
            }
        }
        : undefined;
    const typeAnimal = typeAnimalId
        ? {
            connect: {
                id: typeAnimalId
            }
        }
        : undefined;
    const result = await prisma_client_1.prisma.animal.update({
        data: {
            castrated,
            dateExit,
            description,
            linkPhoto,
            name,
            race,
            sex,
            status,
            home,
            typeAnimal
        },
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
            services: true
        }
    });
    return result;
};
exports.updateAnimal = updateAnimal;
