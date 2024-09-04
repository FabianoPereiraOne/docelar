"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.useGetArrayEntity = void 0;
const useGetArrayEntity = async ({ listEntity, functionGet }) => {
    const resultQuery = await Promise.all(listEntity.map(async (entity) => {
        const result = await functionGet(entity.id);
        return result;
    }));
    return resultQuery;
};
exports.useGetArrayEntity = useGetArrayEntity;
