"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.updateDocument = void 0;
const prisma_client_1 = require("../../../database/prisma-client");
const updateDocument = async ({ id, animalId, key, serviceId }) => {
    const animal = animalId
        ? {
            connect: {
                id: animalId
            }
        }
        : undefined;
    const service = serviceId
        ? {
            connect: {
                id: serviceId
            }
        }
        : undefined;
    const result = await prisma_client_1.prisma.document.update({
        where: {
            id
        },
        data: {
            key,
            animal,
            service
        }
    });
    return result;
};
exports.updateDocument = updateDocument;
