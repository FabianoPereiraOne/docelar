/*
  Warnings:

  - The primary key for the `procedures` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The `id` column on the `procedures` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The primary key for the `proceduresOnSer` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The primary key for the `typesAnimals` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The `id` column on the `typesAnimals` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - Changed the type of `typeAnimalId` on the `animals` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.
  - Changed the type of `procedureId` on the `proceduresOnSer` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.

*/
-- DropForeignKey
ALTER TABLE "animals" DROP CONSTRAINT "animals_typeAnimalId_fkey";

-- DropForeignKey
ALTER TABLE "proceduresOnSer" DROP CONSTRAINT "proceduresOnSer_procedureId_fkey";

-- AlterTable
ALTER TABLE "animals" DROP COLUMN "typeAnimalId",
ADD COLUMN     "typeAnimalId" INTEGER NOT NULL;

-- AlterTable
ALTER TABLE "procedures" DROP CONSTRAINT "procedures_pkey",
DROP COLUMN "id",
ADD COLUMN     "id" SERIAL NOT NULL,
ADD CONSTRAINT "procedures_pkey" PRIMARY KEY ("id");

-- AlterTable
ALTER TABLE "proceduresOnSer" DROP CONSTRAINT "proceduresOnSer_pkey",
DROP COLUMN "procedureId",
ADD COLUMN     "procedureId" INTEGER NOT NULL,
ADD CONSTRAINT "proceduresOnSer_pkey" PRIMARY KEY ("serviceId", "procedureId");

-- AlterTable
ALTER TABLE "typesAnimals" DROP CONSTRAINT "typesAnimals_pkey",
DROP COLUMN "id",
ADD COLUMN     "id" SERIAL NOT NULL,
ADD CONSTRAINT "typesAnimals_pkey" PRIMARY KEY ("id");

-- AddForeignKey
ALTER TABLE "animals" ADD CONSTRAINT "animals_typeAnimalId_fkey" FOREIGN KEY ("typeAnimalId") REFERENCES "typesAnimals"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "proceduresOnSer" ADD CONSTRAINT "proceduresOnSer_procedureId_fkey" FOREIGN KEY ("procedureId") REFERENCES "procedures"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
