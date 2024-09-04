"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.default = RoutesInitController;
const animals_1 = __importDefault(require("./animals"));
const collaborators_1 = __importDefault(require("./collaborators"));
const doctors_1 = __importDefault(require("./doctors"));
const homes_1 = __importDefault(require("./homes"));
const procedures_1 = __importDefault(require("./procedures"));
const services_1 = __importDefault(require("./services"));
const sign_1 = __importDefault(require("./sign"));
const typesAnimals_1 = __importDefault(require("./typesAnimals"));
async function RoutesInitController(server) {
    (0, collaborators_1.default)(server);
    (0, sign_1.default)(server);
    (0, homes_1.default)(server);
    (0, animals_1.default)(server);
    (0, typesAnimals_1.default)(server);
    (0, doctors_1.default)(server);
    (0, procedures_1.default)(server);
    (0, services_1.default)(server);
}
