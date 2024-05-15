/*
  Warnings:

  - You are about to drop the column `linkImage` on the `animals` table. All the data in the column will be lost.
  - You are about to drop the column `name` on the `procedures` table. All the data in the column will be lost.
  - Added the required column `description` to the `procedures` table without a default value. This is not possible if the table is not empty.
  - Added the required column `doctorId` to the `procedures` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "animals" DROP COLUMN "linkImage",
ADD COLUMN     "linkPhoto" TEXT;

-- AlterTable
ALTER TABLE "doctors" ALTER COLUMN "status" SET DEFAULT true;

-- AlterTable
ALTER TABLE "procedures" DROP COLUMN "name",
ADD COLUMN     "description" TEXT NOT NULL,
ADD COLUMN     "doctorId" TEXT NOT NULL,
ADD COLUMN     "sheetId" TEXT,
ALTER COLUMN "status" SET DEFAULT true;

-- AddForeignKey
ALTER TABLE "procedures" ADD CONSTRAINT "procedures_doctorId_fkey" FOREIGN KEY ("doctorId") REFERENCES "doctors"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "procedures" ADD CONSTRAINT "procedures_sheetId_fkey" FOREIGN KEY ("sheetId") REFERENCES "sheets"("id") ON DELETE SET NULL ON UPDATE CASCADE;
