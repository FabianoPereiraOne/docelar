/*
  Warnings:

  - You are about to drop the column `linkPhoto` on the `animals` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "animals" DROP COLUMN "linkPhoto";

-- CreateTable
CREATE TABLE "documents" (
    "id" SERIAL NOT NULL,
    "key" TEXT NOT NULL,
    "animalId" TEXT,
    "serviceId" TEXT,

    CONSTRAINT "documents_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "documents" ADD CONSTRAINT "documents_animalId_fkey" FOREIGN KEY ("animalId") REFERENCES "animals"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "documents" ADD CONSTRAINT "documents_serviceId_fkey" FOREIGN KEY ("serviceId") REFERENCES "services"("id") ON DELETE CASCADE ON UPDATE CASCADE;
