"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const child_process_1 = require("child_process");
const dotenv_1 = __importDefault(require("dotenv"));
const fs_1 = __importDefault(require("fs"));
const path_1 = __importDefault(require("path"));
dotenv_1.default.config();
const useCreateBackup = () => {
    function createBackup() {
        const backupsDir = path_1.default.resolve(__dirname, "../database/backups");
        const backupPath = path_1.default.join(backupsDir, `backup-${Date.now()}.sql`);
        if (!fs_1.default.existsSync(backupsDir))
            fs_1.default.mkdirSync(backupsDir, { recursive: true });
        const connectionString = `postgres://${process.env.POSTGRES_USER}:${process.env.POSTGRES_PASSWORD}@${process.env.POSTGRES_DB_HOST}:${process.env.POSTGRES_DB_PORT}/${process.env.POSTGRES_DB}?sslmode=require`;
        const command = `pg_dump -U ${process.env.POSTGRES_USER} -h ${process.env.POSTGRES_DB_HOST} -p ${process.env.POSTGRES_DB_PORT} -d ${connectionString} -f "${backupPath}"`;
        const passwordCommand = `set PGPASSWORD=${process.env.POSTGRES_PASSWORD} && ${command}`;
        (0, child_process_1.exec)(passwordCommand, (error, stdout, stderr) => {
            if (error)
                return console.error(`Erro ao criar backup: ${error.message}`);
            if (stderr)
                return console.error(`Avisos: ${stderr}`);
            console.log(`Backup criado com sucesso.`);
        });
    }
    return { createBackup };
};
exports.default = useCreateBackup;
