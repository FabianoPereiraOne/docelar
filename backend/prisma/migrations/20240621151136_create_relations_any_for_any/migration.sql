/*
  Warnings:

  - You are about to drop the `doctorsOnServices` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `proceduresOnSer` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE "doctorsOnServices" DROP CONSTRAINT "doctorsOnServices_doctorId_fkey";

-- DropForeignKey
ALTER TABLE "doctorsOnServices" DROP CONSTRAINT "doctorsOnServices_serviceId_fkey";

-- DropForeignKey
ALTER TABLE "proceduresOnSer" DROP CONSTRAINT "proceduresOnSer_procedureId_fkey";

-- DropForeignKey
ALTER TABLE "proceduresOnSer" DROP CONSTRAINT "proceduresOnSer_serviceId_fkey";

-- DropTable
DROP TABLE "doctorsOnServices";

-- DropTable
DROP TABLE "proceduresOnSer";

-- CreateTable
CREATE TABLE "_doctorsOnServices" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "_proceduresOnServices" (
    "A" INTEGER NOT NULL,
    "B" TEXT NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "_doctorsOnServices_AB_unique" ON "_doctorsOnServices"("A", "B");

-- CreateIndex
CREATE INDEX "_doctorsOnServices_B_index" ON "_doctorsOnServices"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_proceduresOnServices_AB_unique" ON "_proceduresOnServices"("A", "B");

-- CreateIndex
CREATE INDEX "_proceduresOnServices_B_index" ON "_proceduresOnServices"("B");

-- AddForeignKey
ALTER TABLE "_doctorsOnServices" ADD CONSTRAINT "_doctorsOnServices_A_fkey" FOREIGN KEY ("A") REFERENCES "doctors"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_doctorsOnServices" ADD CONSTRAINT "_doctorsOnServices_B_fkey" FOREIGN KEY ("B") REFERENCES "services"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_proceduresOnServices" ADD CONSTRAINT "_proceduresOnServices_A_fkey" FOREIGN KEY ("A") REFERENCES "procedures"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_proceduresOnServices" ADD CONSTRAINT "_proceduresOnServices_B_fkey" FOREIGN KEY ("B") REFERENCES "services"("id") ON DELETE CASCADE ON UPDATE CASCADE;
