"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.useReturnValidID = void 0;
const useReturnValidID = (list) => {
    const listValid = list
        .filter(item => item != null)
        .map(item => {
        return { id: item.id };
    });
    return listValid;
};
exports.useReturnValidID = useReturnValidID;
