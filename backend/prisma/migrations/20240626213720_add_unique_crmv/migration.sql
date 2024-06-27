/*
  Warnings:

  - A unique constraint covering the columns `[crmv]` on the table `doctors` will be added. If there are existing duplicate values, this will fail.

*/
-- CreateIndex
CREATE UNIQUE INDEX "doctors_crmv_key" ON "doctors"("crmv");
