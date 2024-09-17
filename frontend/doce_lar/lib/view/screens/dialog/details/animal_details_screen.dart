import 'package:doce_lar/controller/login_controller.dart';
import 'package:doce_lar/model/models/animal_model.dart';
import 'package:doce_lar/model/models/service_model.dart';
import 'package:doce_lar/model/repositories/animals_repository.dart';
import 'package:doce_lar/model/repositories/animals_types_repository.dart';
import 'package:doce_lar/model/repositories/homes_repository.dart';
import 'package:doce_lar/model/repositories/service_repository.dart';
import 'package:doce_lar/view/screens/dialog/details/service_details_screen.dart';
import 'package:doce_lar/view/screens/dialog/add/service_dialog.dart';
import 'package:doce_lar/view/widgets/format_date.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void showAnimalDetailDialog(
    BuildContext context, Animal animal, Function() onAnimalUpdated) async {
  final loginProvider = Provider.of<LoginController>(context, listen: false);
  final homeRepository = HomeRepository();
  final animalTypeRepository = AnimalTypeRepository();

  String homeAddress = 'Carregando...';
  String animalTypeName = 'Carregando...';

  if (animal.homeId != null) {
    try {
      final home = await homeRepository.fetchHomeById(
          animal.homeId!, loginProvider.token);
      homeAddress =
          '${home.address}, ${home.number}, ${home.district}, ${home.city}, ${home.state}';
    } catch (e) {
      homeAddress = 'Erro ao carregar endereço';
    }
  }

  if (animal.typeAnimalId != null) {
    try {
      final animalType = await animalTypeRepository.fetchAnimalTypeById(
          animal.typeAnimalId!, loginProvider.token);
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
                  height: 500,
                  child: TabBarView(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20),
                            Center(
                              child: Text(animal.name ?? 'N/A',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold)),
                            ),
                            _buildDetailRow('Tipo de Animal', animalTypeName),
                            _buildDetailRow('Raça', animal.race),
                            _buildDetailRow('Sexo',
                                animal.sex == 'M' ? 'Masculino' : 'Feminino'),
                            _buildDetailRow('Castrado',
                                animal.castrated == true ? 'Sim' : 'Não'),
                            _buildDetailRow('Status',
                                animal.status == true ? 'Ativo' : 'Inativo'),
                            _buildDetailRow('Data de entrada',
                                formatDate(animal.createdAt)),
                            _buildDetailRow(
                                'Data de Saída', formatDate(animal.dateExit)),

                            //exibindo endereço do lar temporário
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Endereço do Lar Temporário',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 5),
                                  Container(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      homeAddress,
                                      style: TextStyle(color: Colors.grey[700]),
                                      textAlign: TextAlign.left,
                                      softWrap: true,
                                    ),
                                  ),
                                  Divider()
                                ],
                              ),
                            ),
                            // Exibindo a descrição com largura fixa
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Descrição',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 5),
                                  Container(
                                    width: 300, // Largura fixa
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey, width: 1.0),
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    child: Text(
                                      animal.description!,
                                      style: TextStyle(color: Colors.grey[700]),
                                      textAlign: TextAlign.left,
                                      softWrap: true, // Quebrar linhas
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Fechar o diálogo
                                    _showEditAnimalDialog(
                                        context, animal, onAnimalUpdated);
                                  },
                                  child: Text('Editar'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Fechar o diálogo
                                    _confirmDeleteAnimal(
                                        context, animal.id!, onAnimalUpdated);
                                  },
                                  child: Text('Deletar'),
                                  style: TextButton.styleFrom(
                                      foregroundColor: Colors.red),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      FutureBuilder<List<Service>>(
                        future: _fetchServicesWithProcedures(animal.services?.map((s) => s.id ?? '').toList() ?? [], loginProvider.token),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }

                          if (snapshot.hasError) {
                            return Center(child: Text('Erro ao carregar serviços'));
                          }

                          final services = snapshot.data;

                          return Column(
                            children: [
                              services != null && services.isNotEmpty
                                  ? Expanded(
                                      child: ListView.builder(
                                        itemCount: services.length,
                                        itemBuilder: (context, index) {
                                          final service = services[index];
                                          return ListTile(
                                            title: Text(formatDate(service.createdAt)),
                                            subtitle: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                if (service.procedures != null)
                                                  ...service.procedures!.map(
                                                    (procedure) => Text('${procedure.name}'),
                                                  ).toList(),
                                              ],
                                            ),
                                            onTap: () {
                                              // Exibir detalhes do serviço ao clicar
                                              showServiceDetailsDialog(context, service.id!, () {
                                                Navigator.of(context).pop();
                                                onAnimalUpdated();
                                              });
                                            },
                                          );
                                        },
                                      ),
                                    )
                                  : Center(
                                      child: Text('Nenhum serviço encontrado para este animal.')),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      showServiceDialog(context, animal.id!, onAnimalUpdated);
                                    },
                                    child: Text('Adicionar Serviço'),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Fechar'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<List<Service>> _fetchServicesWithProcedures(List<String> serviceIds, String token) async {
  final serviceRepository = ServiceRepository();
  final services = <Service>[];

  for (String serviceId in serviceIds) {
    try {
      final service = await serviceRepository.getServiceById(serviceId, token);
      services.add(service);
    } catch (e) {
      print('Erro ao carregar serviço: $e');
    }
  }

  // Ordenar os serviços do mais novo para o mais antigo
  services.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

  return services;
}


void _confirmDeleteAnimal(
    BuildContext context, String animalId, Function() onAnimalDeleted) {
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
              await animalRepository.deleteAnimal(
                  animalId, loginProvider.token);
              Navigator.of(context).pop();
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
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
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
      ),
      Divider(), // Linha abaixo do detalhe
    ],
  );
}

void _showEditAnimalDialog(
    BuildContext context, Animal animal, Function() onAnimalUpdated) {
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
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Descrição',
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                    controller: descriptionController,
                    maxLines: 5,
                    minLines: 3,
                    keyboardType: TextInputType.multiline,
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

                    await animalRepository.updateAnimal(
                        updatedAnimal, loginProvider.token);

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
