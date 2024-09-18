import 'package:doce_lar/controller/login_controller.dart';
import 'package:doce_lar/model/models/animal_model.dart';
import 'package:doce_lar/model/models/homes_model.dart';
import 'package:doce_lar/model/models/service_model.dart';
import 'package:doce_lar/model/models/user_model.dart';
import 'package:doce_lar/model/repositories/animals_repository.dart';
import 'package:doce_lar/model/repositories/colaborador_repository.dart';
import 'package:doce_lar/model/repositories/service_repository.dart';
import 'package:doce_lar/view/screens/dialog/details/service_details_screen.dart';
import 'package:doce_lar/view/screens/dialog/add/service_dialog.dart';
import 'package:doce_lar/view/widgets/confirm_delete.dart';
import 'package:doce_lar/view/widgets/detail_row.dart';
import 'package:doce_lar/view/widgets/feedback_snackbar.dart';
import 'package:doce_lar/view/widgets/format_date.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void showAnimalDetailDialog(BuildContext context, Animal animal,
    List<Usuario> colaboradores, Function() onAnimalUpdated) async {
  // Mostra um CircularProgressIndicator enquanto carrega os dados
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Center(child: CircularProgressIndicator());
    },
  );

  final loginProvider = Provider.of<LoginController>(context, listen: false);
  final colaboradorRepository = ColaboradorRepository();

  String colaboradorName = 'N/A';

  // Tenta buscar o nome do colaborador se o ID estiver disponível
  if (animal.home?.collaboratorId != null) {
    try {
      final colaborador = await colaboradorRepository.fetchColaboradorById(
        animal.home!.collaboratorId!,
        loginProvider.token,
      );
      colaboradorName = colaborador.name ?? 'N/A';
    } catch (e) {
      colaboradorName = 'Erro ao carregar colaborador';
    }
  }

  // Fecha o CircularProgressIndicator e abre o diálogo com os detalhes
  Navigator.of(context).pop();

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
                            DetailRow(
                                label: 'Tipo de Animal', value: animal.typeAnimal!.type),
                            DetailRow(label: 'Raça', value: animal.race),
                            DetailRow(
                                label: 'Sexo',
                                value: animal.sex == 'M'
                                    ? 'Macho'
                                    : 'Fêmea'),
                            DetailRow(
                                label: 'Castrado',
                                value:
                                    animal.castrated == true ? 'Sim' : 'Não'),
                            DetailRow(
                                label: 'Status',
                                value: animal.status == true
                                    ? 'Ativo'
                                    : 'Inativo'),
                            DetailRow(
                                label: 'Data de entrada',
                                value: formatDate(animal.createdAt)),
                            DetailRow(
                                label: 'Data de Saída',
                                value: formatDate(animal.dateExit)),
                            DetailRow(
                                label: 'Colaborador Responsável',
                                value: colaboradorName), // Exibe o nome do colaborador
                            // Exibir endereço do lar temporário
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
                                      '${animal.home?.address}, ${animal.home?.number}, ${animal.home?.address}, ${animal.home?.city} - ${animal.home?.state}',
                                      style: TextStyle(color: Colors.grey[700]),
                                      textAlign: TextAlign.left,
                                      softWrap: true,
                                    ),
                                  ),
                                  Divider(),
                                ],
                              ),
                            ),
                            // Exibir descrição com largura fixa
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
                                      animal.description ?? 'Nenhuma descrição disponível',
                                      style: TextStyle(color: Colors.grey[700]),
                                      textAlign: TextAlign.left,
                                      softWrap: true,
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
                                    _showEditAnimalDialog(context, animal,
                                        colaboradores, onAnimalUpdated);
                                  },
                                  child: Text('Editar'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Fechar o diálogo
                                    _showDeleteDialog(
                                      context,
                                      animal.id!,
                                      'animals',
                                      'animal',
                                      onAnimalUpdated,
                                    );
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
                        future: _fetchServicesWithProcedures(
                            animal.services?.map((s) => s.id ?? '').toList() ?? [],
                            loginProvider.token),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }

                          if (snapshot.hasError) {
                            return Center(
                                child: Text('Erro ao carregar serviços'));
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
                                            title: Text(
                                                formatDate(service.createdAt)),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                if (service.procedures != null)
                                                  ...service.procedures!.map(
                                                    (procedure) => Text(
                                                        '${procedure.name}'),
                                                  ),
                                              ],
                                            ),
                                            onTap: () {
                                              // Exibir detalhes do serviço ao clicar
                                              showServiceDetailsDialog(
                                                  context, service.id!, () {
                                                Navigator.of(context).pop();
                                                onAnimalUpdated();
                                              });
                                            },
                                          );
                                        },
                                      ),
                                    )
                                  : Center(
                                      child: Text(
                                          'Nenhum serviço encontrado para este animal.'),
                                    ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      showServiceDialog(
                                          context, animal.id!, onAnimalUpdated);
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



void _showDeleteDialog(
  BuildContext context,
  String itemId,
  String route,
  String entityType,
  Function() onDeleted,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return DeleteConfirmationDialog(
        itemId: itemId,
        route: route,
        entityType: entityType,
        onDeleted: onDeleted,
      );
    },
  );
}

Future<List<Service>> _fetchServicesWithProcedures(
    List<String> serviceIds, String token) async {
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

void _showEditAnimalDialog(BuildContext context, Animal animal,
    List<Usuario> colaboradores, Function() onAnimalUpdated) {
  final TextEditingController nameController =
      TextEditingController(text: animal.name ?? '');
  final TextEditingController descriptionController =
      TextEditingController(text: animal.description ?? '');
  final TextEditingController raceController =
      TextEditingController(text: animal.race ?? '');
  final TextEditingController linkPhotoController =
      TextEditingController(text: animal.linkPhoto ?? '');

  final selectedType = animal.typeAnimal; // Atualize conforme necessário
  String sex = animal.sex ?? 'M';
  bool castrated = animal.castrated ?? false;
  bool status = animal.status ?? true;

  // Encontre o colaborador atual com base no objeto home no animal
  Usuario? currentCollaborator = colaboradores.firstWhere(
      (collaborator) =>
          collaborator.id == animal.home?.collaboratorId,
      orElse: () => Usuario(), // Return an empty Usuario object instead of null
      );

  String? selectedCollaboratorId = currentCollaborator.id;
  String? selectedHomeId = animal.home?.id;

  // Obter os endereços do colaborador selecionado
  List<DropdownMenuItem<String>> homeItems = [];
  if (selectedCollaboratorId != null) {
    final selectedCollaborator = colaboradores.firstWhere(
        (collaborator) => collaborator.id == selectedCollaboratorId,
        orElse: () => Usuario() // Forneça um valor padrão para evitar null
        );
    final homes =
        selectedCollaborator.homes?.cast<Map<String, dynamic>>() ?? [];
    final homeIds = <String>{}; // Conjunto para garantir valores únicos
    homeItems = homes.where((home) {
      final homeId = home['id'] as String;
      return homeIds.add(homeId); // Adiciona ao conjunto e verifica duplicatas
    }).map((home) {
      return DropdownMenuItem<String>(
        value: home['id'] as String,
        child: Text('${home['address']}, ${home['number']}'),
      );
    }).toList();
  }

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
                  DropdownButtonFormField<String>(
                    value: selectedCollaboratorId,
                    decoration: InputDecoration(labelText: 'Colaborador'),
                    items: colaboradores
                        .map((collaborator) {
                          return DropdownMenuItem<String>(
                            child: Text(collaborator.name ?? 'Desconhecido'),
                            value: collaborator.id,
                          );
                        })
                        .toList(), // Remove o uso de Set para garantir que a lista não tenha duplicatas
                    onChanged: (value) {
                      setState(() {
                        selectedCollaboratorId = value;
                        selectedHomeId = null; // Reset selected home when changing collaborator
                        if (value != null) {
                          final selectedCollaborator = colaboradores.firstWhere(
                              (collaborator) => collaborator.id == value,
                              orElse: () => Usuario());
                          final homes = selectedCollaborator.homes
                                  ?.cast<Map<String, dynamic>>() ?? [];
                          final homeIds =
                              <String>{}; // Conjunto para garantir valores únicos
                          homeItems = homes.where((home) {
                            final homeId = home['id'] as String;
                            return homeIds.add(
                                homeId); // Adiciona ao conjunto e verifica duplicatas
                          }).map((home) {
                            return DropdownMenuItem<String>(
                              value: home['id'] as String,
                              child:
                                  Text('${home['address']}, ${home['number']}'),
                            );
                          }).toList();
                        }
                      });
                    },
                  ),
                  if (selectedCollaboratorId != null)
                    DropdownButtonFormField<String>(
                      value: selectedHomeId,
                      decoration: InputDecoration(labelText: 'Endereço'),
                      items: homeItems,
                      onChanged: (value) {
                        setState(() {
                          selectedHomeId = value;
                        });
                      },
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
                      typeAnimal: selectedType,
                      dateExit: animal.dateExit,
                      status: status,
                      createdAt: animal.createdAt,
                      home: selectedHomeId != null
                          ? Home(id: selectedHomeId)
                          : null,
                    );

                    await animalRepository.updateAnimal(
                        updatedAnimal, loginProvider.token);

                    Navigator.of(context).pop(); // Fechar o diálogo de edição
                    onAnimalUpdated(); // Atualizar a tela principal
                  } catch (e) {
                    TopSnackBar.show(context, 'Erro ao editar animal', false);
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
