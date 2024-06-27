/*
  Warnings:

  - Added the required column `district` to the `doctors` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "doctors" ADD COLUMN     "district" TEXT NOT NULL;
