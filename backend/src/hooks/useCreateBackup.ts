import { exec } from "child_process"
import dotenv from "dotenv"
import fs from "fs"
import path from "path"

dotenv.config()

const useCreateBackup = () => {
  function createBackup() {
    const backupsDir = path.resolve(__dirname, "../database/backups")
    const backupPath = path.join(backupsDir, `backup-${Date.now()}.sql`)

    if (!fs.existsSync(backupsDir))
      fs.mkdirSync(backupsDir, { recursive: true })

    const connectionString = `postgres://${process.env.POSTGRES_USER}:${process.env.POSTGRES_PASSWORD}@${process.env.POSTGRES_DB_HOST}:${process.env.POSTGRES_DB_PORT}/${process.env.POSTGRES_DB}?sslmode=require`

    const command = `pg_dump -U ${process.env.POSTGRES_USER} -h ${process.env.POSTGRES_DB_HOST} -p ${process.env.POSTGRES_DB_PORT} -d ${connectionString} -f "${backupPath}"`

    const passwordCommand = `set PGPASSWORD=${process.env.POSTGRES_PASSWORD} && ${command}`

    exec(passwordCommand, (error, stdout, stderr) => {
      if (error) return console.error(`Erro ao criar backup: ${error.message}`)
      if (stderr) return console.error(`Avisos: ${stderr}`)

      console.log(`Backup criado com sucesso.`)
    })
  }

  return { createBackup }
}

export default useCreateBackup
