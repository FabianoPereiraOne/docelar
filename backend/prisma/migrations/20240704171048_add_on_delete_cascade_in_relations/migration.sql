-- DropForeignKey
ALTER TABLE "animals" DROP CONSTRAINT "animals_homeId_fkey";

-- DropForeignKey
ALTER TABLE "animals" DROP CONSTRAINT "animals_typeAnimalId_fkey";

-- DropForeignKey
ALTER TABLE "homes" DROP CONSTRAINT "homes_collaboratorId_fkey";

-- DropForeignKey
ALTER TABLE "services" DROP CONSTRAINT "services_animalId_fkey";

-- AddForeignKey
ALTER TABLE "homes" ADD CONSTRAINT "homes_collaboratorId_fkey" FOREIGN KEY ("collaboratorId") REFERENCES "collaborators"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "animals" ADD CONSTRAINT "animals_homeId_fkey" FOREIGN KEY ("homeId") REFERENCES "homes"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "animals" ADD CONSTRAINT "animals_typeAnimalId_fkey" FOREIGN KEY ("typeAnimalId") REFERENCES "typesAnimals"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "services" ADD CONSTRAINT "services_animalId_fkey" FOREIGN KEY ("animalId") REFERENCES "animals"("id") ON DELETE CASCADE ON UPDATE CASCADE;
