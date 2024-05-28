/*
  Warnings:

  - You are about to drop the column `status` on the `collaborators` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "collaborators" DROP COLUMN "status",
ADD COLUMN     "statusAccount" BOOLEAN NOT NULL DEFAULT true;
