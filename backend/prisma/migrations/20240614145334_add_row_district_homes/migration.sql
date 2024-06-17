/*
  Warnings:

  - Added the required column `district` to the `homes` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "animals" ALTER COLUMN "sex" SET DATA TYPE TEXT;

-- AlterTable
ALTER TABLE "doctors" ALTER COLUMN "cep" SET DATA TYPE TEXT;

-- AlterTable
ALTER TABLE "homes" ADD COLUMN     "district" TEXT NOT NULL,
ALTER COLUMN "cep" SET DATA TYPE TEXT;
