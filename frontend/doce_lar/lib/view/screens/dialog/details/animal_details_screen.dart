

import 'package:doce_lar/controller/login_controller.dart';
import 'package:doce_lar/model/models/animal_model.dart';
import 'package:doce_lar/model/repositories/animals_repository.dart';
import 'package:doce_lar/model/repositories/animals_types_repository.dart';
import 'package:doce_lar/model/repositories/homes_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void showAnimalDetailDialog(BuildContext context, Animal animal, Function() onAnimalUpdated) async {
  final loginProvider = Provider.of<LoginController>(context, listen: false);
  final homeRepository = HomeRepository();
  final animalTypeRepository = AnimalTypeRepository();

  String homeAddress = 'Carregando...';
  String animalTypeName = 'Carregando...';

  if (animal.homeId != null) {
    try {
      final home = await homeRepository.fetchHomeById(animal.homeId!, loginProvider.token);
      homeAddress = '${home.address}, ${home.number}, ${home.district}, ${home.city}, ${home.state}';
    } catch (e) {
      homeAddress = 'Erro ao carregar endereço';
    }
  }

  if (animal.typeAnimalId != null) {
    try {
      final animalType = await animalTypeRepository.fetchAnimalTypeById(animal.typeAnimalId!, loginProvider.token);
      animalTypeName = animalType.type ?? 'Desconhecido';
    } catch (e) {
      animalTypeName = 'Erro ao carregar tipo de animal';
    }
  }

  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        child: DefaultTabController(
          length: 2,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                color: Colors.white,
                child: TabBar(
                  tabs: [
                    Tab(text: 'Detalhes'),
                    Tab(text: 'Serviços'),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 300,
                  child: TabBarView(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20),
                            _buildDetailRow('Descrição', animal.description),
                            _buildDetailRow('Raça', animal.race),
                            _buildDetailRow('Sexo', animal.sex == 'M' ? 'Masculino' : 'Feminino'),
                            _buildDetailRow('Castrado', animal.castrated == true ? 'Sim' : 'Não'),
                            _buildDetailRow('Status', animal.status == true ? 'Ativo' : 'Inativo'),
                            _buildDetailRow('Data de Saída', animal.dateExit ?? 'N/A'),
                            _buildDetailRow('Tipo de Animal', animalTypeName),
                            _buildDetailRow('Endereço da Casa', homeAddress),
                            _buildDetailRow('Data de entrada', animal.createdAt),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          animal.services != null && animal.services!.isNotEmpty
                              ? Expanded(
                                  child: ListView.builder(
                                    itemCount: animal.services!.length,
                                    itemBuilder: (context, index) {
                                      final service = animal.services![index];
                                      return ListTile(
                                        title: Text(service.createdAt ?? 'Serviço Desconhecido'),
                                        subtitle: Text('Descrição: ${service.description}'),
                                      );
                                    },
                                  ),
                                )
                              : Text('Nenhum serviço encontrado para este animal.'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Fechar'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _showEditAnimalDialog(context, animal, onAnimalUpdated);
                    },
                    child: Text('Editar'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _confirmDeleteAnimal(context, animal.id!, onAnimalUpdated);
                    },
                    child: Text('Deletar'),
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}


void _confirmDeleteAnimal(BuildContext context, String animalId, Function() onAnimalDeleted) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Confirmar Exclusão'),
      content: Text('Tem certeza que deseja excluir este animal?'),
      actions: [
        TextButton(
          child: Text('Cancelar'),
          onPressed: () {
            Navigator.of(context).pop(); // Fechar o diálogo de confirmação
          },
        ),
        ElevatedButton(
          child: Text('Deletar'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () async {
            final loginProvider =
                Provider.of<LoginController>(context, listen: false);
            final animalRepository = AnimalRepository();

            try {
              await animalRepository.deleteAnimal(animalId, loginProvider.token);
              Navigator.of(context).pop(); // Fechar o diálogo de confirmação
              onAnimalDeleted(); // Atualizar a tela principal
            } catch (e) {
              print('Erro ao excluir animal: $e');
            }
          },
        ),
      ],
    ),
  );
}


Widget _buildDetailRow(String label, String? value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Flexible(
          child: Text(
            value ?? 'N/A',
            style: TextStyle(color: Colors.grey[700]),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    ),
  );
}

void _showEditAnimalDialog(BuildContext context, Animal animal, Function() onAnimalUpdated) {
  final TextEditingController nameController =
      TextEditingController(text: animal.name ?? '');
  final TextEditingController descriptionController =
      TextEditingController(text: animal.description ?? '');
  final TextEditingController raceController =
      TextEditingController(text: animal.race ?? '');
  final TextEditingController linkPhotoController =
      TextEditingController(text: animal.linkPhoto ?? '');

  int selectedTypeId = animal.typeAnimalId ?? 1;
  String sex = animal.sex ?? 'M';
  bool castrated = animal.castrated ?? false;
  bool status = animal.status ?? true;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Editar Animal'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: InputDecoration(labelText: 'Nome'),
                    controller: nameController,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Descrição'),
                    controller: descriptionController,
                  ),
                  DropdownButtonFormField<String>(
                    value: sex,
                    decoration: InputDecoration(labelText: 'Sexo'),
                    items: [
                      DropdownMenuItem(child: Text('Masculino'), value: 'M'),
                      DropdownMenuItem(child: Text('Feminino'), value: 'F'),
                    ],
                    onChanged: (value) {
                      setState(() {
                        sex = value!;
                      });
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Raça'),
                    controller: raceController,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Link da Foto'),
                    controller: linkPhotoController,
                  ),
                  SwitchListTile(
                    title: Text('Castrado'),
                    value: castrated,
                    onChanged: (value) {
                      setState(() {
                        castrated = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: Text('Status'),
                    value: status,
                    onChanged: (value) {
                      setState(() {
                        status = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                child: Text('Salvar'),
                onPressed: () async {
                  final loginProvider =
                      Provider.of<LoginController>(context, listen: false);
                  final animalRepository = AnimalRepository();

                  try {
                    final updatedAnimal = Animal(
                      id: animal.id,
                      name: nameController.text,
                      description: descriptionController.text,
                      sex: sex,
                      castrated: castrated,
                      race: raceController.text,
                      linkPhoto: linkPhotoController.text,
                      typeAnimalId: selectedTypeId,
                      updatedAt: DateTime.now().toString(),
                      dateExit: animal.dateExit,
                      status: status,
                      createdAt: animal.createdAt,
                      homeId: animal.homeId,
                    );

                    await animalRepository.updateAnimal(updatedAnimal, loginProvider.token);

                    Navigator.of(context).pop(); // Fechar o diálogo de edição
                    onAnimalUpdated(); // Atualizar a tela principal
                  } catch (e) {
                    print('Erro ao editar animal: $e');
                  }
                },
              ),
            ],
          );
        },
      );
    },
  );
  
}
