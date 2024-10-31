"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.fetchDocument = void 0;
const prisma_client_1 = require("../../../database/prisma-client");
const fetchDocument = async ({ id }) => {
    const result = await prisma_client_1.prisma.document.findFirst({
        where: {
            id
        }
    });
    return result;
};
exports.fetchDocument = fetchDocument;
