/*
  Warnings:

  - You are about to drop the column `typeId` on the `animals` table. All the data in the column will be lost.
  - You are about to drop the column `address` on the `collaborators` table. All the data in the column will be lost.
  - You are about to drop the column `cep` on the `collaborators` table. All the data in the column will be lost.
  - You are about to drop the column `city` on the `collaborators` table. All the data in the column will be lost.
  - You are about to drop the column `number` on the `collaborators` table. All the data in the column will be lost.
  - You are about to drop the column `role` on the `collaborators` table. All the data in the column will be lost.
  - You are about to drop the column `state` on the `collaborators` table. All the data in the column will be lost.
  - The `type` column on the `collaborators` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - You are about to drop the column `doctorId` on the `procedures` table. All the data in the column will be lost.
  - You are about to drop the column `sheetId` on the `procedures` table. All the data in the column will be lost.
  - You are about to drop the column `status` on the `procedures` table. All the data in the column will be lost.
  - You are about to drop the column `typeId` on the `procedures` table. All the data in the column will be lost.
  - You are about to drop the `sheets` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `types` table. If the table is not empty, all the data it contains will be lost.
  - Added the required column `race` to the `animals` table without a default value. This is not possible if the table is not empty.
  - Added the required column `typeAnimalId` to the `animals` table without a default value. This is not possible if the table is not empty.
  - Added the required column `name` to the `procedures` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "animals" DROP CONSTRAINT "animals_typeId_fkey";

-- DropForeignKey
ALTER TABLE "procedures" DROP CONSTRAINT "procedures_doctorId_fkey";

-- DropForeignKey
ALTER TABLE "procedures" DROP CONSTRAINT "procedures_sheetId_fkey";

-- DropForeignKey
ALTER TABLE "procedures" DROP CONSTRAINT "procedures_typeId_fkey";

-- DropForeignKey
ALTER TABLE "sheets" DROP CONSTRAINT "sheets_animalId_fkey";

-- DropIndex
DROP INDEX "homes_collaboratorId_key";

-- AlterTable
ALTER TABLE "animals" DROP COLUMN "typeId",
ADD COLUMN     "race" TEXT NOT NULL,
ADD COLUMN     "typeAnimalId" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "collaborators" DROP COLUMN "address",
DROP COLUMN "cep",
DROP COLUMN "city",
DROP COLUMN "number",
DROP COLUMN "role",
DROP COLUMN "state",
DROP COLUMN "type",
ADD COLUMN     "type" "Role" NOT NULL DEFAULT 'USER';

-- AlterTable
ALTER TABLE "procedures" DROP COLUMN "doctorId",
DROP COLUMN "sheetId",
DROP COLUMN "status",
DROP COLUMN "typeId",
ADD COLUMN     "name" TEXT NOT NULL;

-- DropTable
DROP TABLE "sheets";

-- DropTable
DROP TABLE "types";

-- CreateTable
CREATE TABLE "typesAnimals" (
    "id" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "typesAnimals_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "services" (
    "id" TEXT NOT NULL,
    "description" TEXT,
    "status" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "animalId" TEXT NOT NULL,

    CONSTRAINT "services_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "doctorsOnServices" (
    "doctorId" TEXT NOT NULL,
    "serviceId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "doctorsOnServices_pkey" PRIMARY KEY ("serviceId","doctorId")
);

-- CreateTable
CREATE TABLE "proceduresOnSer" (
    "serviceId" TEXT NOT NULL,
    "procedureId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "proceduresOnSer_pkey" PRIMARY KEY ("serviceId","procedureId")
);

-- AddForeignKey
ALTER TABLE "animals" ADD CONSTRAINT "animals_typeAnimalId_fkey" FOREIGN KEY ("typeAnimalId") REFERENCES "typesAnimals"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "services" ADD CONSTRAINT "services_animalId_fkey" FOREIGN KEY ("animalId") REFERENCES "animals"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "doctorsOnServices" ADD CONSTRAINT "doctorsOnServices_doctorId_fkey" FOREIGN KEY ("doctorId") REFERENCES "doctors"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "doctorsOnServices" ADD CONSTRAINT "doctorsOnServices_serviceId_fkey" FOREIGN KEY ("serviceId") REFERENCES "services"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "proceduresOnSer" ADD CONSTRAINT "proceduresOnSer_serviceId_fkey" FOREIGN KEY ("serviceId") REFERENCES "services"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "proceduresOnSer" ADD CONSTRAINT "proceduresOnSer_procedureId_fkey" FOREIGN KEY ("procedureId") REFERENCES "procedures"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
