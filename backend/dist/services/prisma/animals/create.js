"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.createAnimal = void 0;
const prisma_client_1 = require("../../../database/prisma-client");
const createAnimal = async ({ name, castrated, dateExit, description, homeId, linkPhoto, race, sex, typeAnimalId }) => {
    const id = Number(typeAnimalId);
    const result = await prisma_client_1.prisma.animal.create({
        data: {
            name,
            description,
            castrated,
            dateExit,
            linkPhoto,
            race,
            sex,
            home: {
                connect: {
                    id: homeId
                }
            },
            typeAnimal: {
                connect: {
                    id
                }
            }
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
exports.createAnimal = createAnimal;
