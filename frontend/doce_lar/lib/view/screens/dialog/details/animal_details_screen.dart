import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:doce_lar/controller/interceptor_dio.dart';
import 'package:doce_lar/controller/login_controller.dart';
import 'package:doce_lar/model/models/animal_model.dart';
import 'package:doce_lar/model/models/animal_type_model.dart';
import 'package:doce_lar/model/models/document_model.dart';
import 'package:doce_lar/model/models/homes_model.dart';
import 'package:doce_lar/model/models/service_model.dart';
import 'package:doce_lar/model/models/user_model.dart';
import 'package:doce_lar/model/repositories/animals_repository.dart';
import 'package:doce_lar/model/repositories/colaborador_repository.dart';
import 'package:doce_lar/model/repositories/service_repository.dart';
import 'package:doce_lar/model/repositories/upload_repository.dart';
import 'package:doce_lar/view/screens/dialog/details/service_details_screen.dart';
import 'package:doce_lar/view/screens/dialog/add/service_dialog.dart';
import 'package:doce_lar/view/widgets/detail_row.dart';
import 'package:doce_lar/view/widgets/feedback_snackbar.dart';
import 'package:doce_lar/view/widgets/format_date.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';

Future<void> showAnimalDetailDialog(
    BuildContext context,
    Animal animal,
    List<AnimalType> animalTypes,
    List<Usuario> colaboradores,
    Function() onAnimalUpdated) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return const Center(child: CircularProgressIndicator());
    },
  );
  final loginProvider = Provider.of<LoginController>(context, listen: false);
  final customDio = CustomDio(loginProvider, context);
  final colaboradorRepository = ColaboradorRepository(customDio);
  String colaboradorName = 'N/A';

  if (animal.home?.collaboratorId != null) {
    try {
      final colaborador = await colaboradorRepository.fetchColaboradorById(
        animal.home!.collaboratorId!,
      );
      colaboradorName = colaborador.name ?? 'N/A';
    } catch (e) {
      colaboradorName = 'Erro ao carregar colaborador';
    }
  }
  Navigator.of(context).pop();
  await showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        child: DefaultTabController(
          length: 3,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      color: Colors.white,
                      child: const TabBar(
                        tabs: [
                          Tab(text: 'Detalhes'),
                          Tab(text: 'Serviços'),
                          Tab(
                            text: 'Fotos',
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 20),
                                  Center(
                                    child: Text(animal.name ?? 'N/A',
                                        style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  DetailRow(
                                      label: 'Tipo de Animal',
                                      value: animal.typeAnimal!.type),
                                  DetailRow(label: 'Raça', value: animal.race),
                                  DetailRow(
                                      label: 'Sexo',
                                      value: animal.sex == 'M'
                                          ? 'Macho'
                                          : 'Fêmea'),
                                  DetailRow(
                                      label: 'Castrado',
                                      value: animal.castrated == true
                                          ? 'Sim'
                                          : 'Não'),
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
                                      value: colaboradorName),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Endereço do Lar Temporário',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 5),
                                        Container(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            '${animal.home?.address}, ${animal.home?.number}, ${animal.home?.city} - ${animal.home?.state}',
                                            style: TextStyle(
                                                color: Colors.grey[700]),
                                            textAlign: TextAlign.left,
                                            softWrap: true,
                                          ),
                                        ),
                                        const Divider(),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Descrição',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 5),
                                        Container(
                                          width: 300,
                                          padding: const EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey, width: 1.0),
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                          child: Text(
                                            animal.description ??
                                                'Nenhuma descrição disponível',
                                            style: TextStyle(
                                                color: Colors.grey[700]),
                                            textAlign: TextAlign.left,
                                            softWrap: true,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () async {
                                          await _showEditAnimalDialog(
                                              context,
                                              animal,
                                              animalTypes,
                                              colaboradores,
                                              onAnimalUpdated);
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Editar'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          FutureBuilder<List<Service>>(
                            future: _fetchServicesWithProcedures(
                                animal.services
                                        ?.map((s) => s.id ?? '')
                                        .toList() ??
                                    [],
                                context),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }

                              if (snapshot.hasError) {
                                return const Center(
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
                                              return Column(
                                                children: [
                                                  ListTile(
                                                    title: Text(formatDate(
                                                        service.createdAt)),
                                                    subtitle: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        if (service
                                                                .procedures !=
                                                            null)
                                                          ...service.procedures!
                                                              .map(
                                                            (procedure) => Text(
                                                                '${procedure.name}'),
                                                          ),
                                                      ],
                                                    ),
                                                    onTap: () async {
                                                      await showServiceDetailsDialog(
                                                          context, service.id!,
                                                          () {
                                                        Navigator.of(context)
                                                            .pop();
                                                        onAnimalUpdated();
                                                      });
                                                    },
                                                  ),
                                                  const Divider(),
                                                ],
                                              );
                                            },
                                          ),
                                        )
                                      : const Center(
                                          child: Text(
                                              'Nenhum serviço encontrado para este animal.')),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () async {
                                          await showServiceDialog(context,
                                              animal.id!, onAnimalUpdated);
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Adicionar Serviço'),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                          FutureBuilder<List<Document>>(
                            future: _fetchUploadedDocuments(context),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }

                              if (snapshot.hasError) {
                                return const Center(
                                    child: Text('Erro ao carregar fotos'));
                              }

                              final documents = snapshot.data;

                              if (documents == null || documents.isEmpty) {
                                return const Center(
                                    child: Text('Nenhuma foto encontrada.'));
                              }

                              return GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3, // Número de colunas
                                  childAspectRatio: 1.0, // Relação de aspecto
                                  crossAxisSpacing:
                                      4.0, // Espaçamento entre as colunas
                                  mainAxisSpacing:
                                      4.0, // Espaçamento entre as linhas
                                ),
                                itemCount: documents.length,
                                itemBuilder: (context, index) {
                                  final document = documents[index];
                                  final imageUrl =
                                      'http://patrick.vps-kinghost.net:7001${document.key}'; // Ajuste a URL conforme necessário

                                  return GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (_) => Dialog(
                                          backgroundColor: Colors.transparent,
                                          child: Stack(
                                            children: [
                                              PhotoView(
                                                imageProvider:
                                                    NetworkImage(imageUrl),
                                                minScale: PhotoViewComputedScale
                                                    .contained,
                                                maxScale: PhotoViewComputedScale
                                                        .covered *
                                                    2,
                                                heroAttributes:
                                                    PhotoViewHeroAttributes(
                                                        tag: imageUrl),
                                              ),
                                              Positioned(
                                                top: 40,
                                                right: 20,
                                                child: IconButton(
                                                  icon: const Icon(
                                                    Icons.close,
                                                    color: Colors.white,
                                                    size: 30,
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(); // Fecha o diálogo
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    child: Image.network(
                                      imageUrl,
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
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
                            child: const Text('Fechar'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    },
  );
}

Future<List<Document>> _fetchUploadedDocuments(BuildContext context) async {
  final loginProvider = Provider.of<LoginController>(context, listen: false);
  final customDio = CustomDio(loginProvider, context);
  final uploadRepository = UploadRepository(customDio);

  return await uploadRepository.fetchDocuments();
}

Future<List<Service>> _fetchServicesWithProcedures(
    List<String> serviceIds, BuildContext context) async {
  final loginProvider = Provider.of<LoginController>(context, listen: false);
  final customDio = CustomDio(loginProvider, context);
  final serviceRepository = ServiceRepository(customDio);
  final services = <Service>[];

  for (String serviceId in serviceIds) {
    try {
      final service = await serviceRepository.getServiceById(serviceId);
      services.add(service);
    } catch (e) {
      log('Erro ao carregar serviço: $e');
    }
  }

  services.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

  return services;
}

Future<void> _showEditAnimalDialog(
    BuildContext context,
    Animal animal,
    List<AnimalType> animalTypes,
    List<Usuario> colaboradores,
    Function() onAnimalUpdated) async {
  final TextEditingController nameController =
      TextEditingController(text: animal.name ?? '');
  final TextEditingController descriptionController =
      TextEditingController(text: animal.description ?? '');
  final TextEditingController raceController =
      TextEditingController(text: animal.race ?? '');

  final selectedType = animal.typeAnimal;
  String sex = animal.sex ?? 'M';
  bool castrated = animal.castrated ?? false;
  bool status = animal.status ?? true;
  final loginProvider = Provider.of<LoginController>(context, listen: false);
  final customDio = CustomDio(loginProvider, context);
  final animalRepository = AnimalRepository(customDio);

  Usuario? currentCollaborator = colaboradores.firstWhere(
    (collaborator) => collaborator.id == animal.home?.collaboratorId,
    orElse: () => Usuario(),
  );

  String? selectedCollaboratorId = currentCollaborator.id;
  String? selectedHomeId = animal.home?.id;

  List<Home> homes = [];
  List<DropdownMenuItem<String>> homeItems = [];

  if (selectedCollaboratorId != null) {
    final selectedCollaborator = colaboradores.firstWhere(
        (collaborator) => collaborator.id == selectedCollaboratorId,
        orElse: () => Usuario());
    homes = selectedCollaborator.homes
            ?.map((homeJson) => Home.fromMap(homeJson))
            .where((home) => home.status == true)
            .toList() ??
        [];

    homeItems = homes.map((home) {
      return DropdownMenuItem<String>(
        value: home.id,
        child: Text('${home.address}, ${home.number}'),
      );
    }).toList();
  }

  bool initialStatus = status; // Armazena o status inicial

  final sexOptions = {
    'Macho': 'M',
    'Fêmea': 'F',
  };

  AnimalType? selectedAnimalType = animalTypes.firstWhere(
    (type) => type.id == selectedType?.id,
    orElse: () => animalTypes.first,
  );

  final typeItems = animalTypes.map((type) {
    return DropdownMenuItem<AnimalType>(
      value: type,
      child: Text(type.type ?? ''),
    );
  }).toList();

  await showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          void updateHomes(Usuario? colaborador) {
            if (colaborador != null) {
              homes = colaborador.homes
                      ?.map((homeJson) => Home.fromMap(homeJson))
                      .where((home) => home.status == true)
                      .toList() ??
                  [];

              if (homes.isEmpty) {
                selectedHomeId = null;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  TopSnackBar.show(
                    context,
                    'O colaborador selecionado não possui lares cadastrados.',
                    false,
                  );
                });
              } else {
                selectedHomeId = null;
              }
            } else {
              homes = [];
              selectedHomeId = null;
            }
          }

          return AlertDialog(
            title: const Text('Editar Animal'),
            content: SingleChildScrollView(
              child: Form(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: const InputDecoration(labelText: 'Nome'),
                      controller: nameController,
                    ),
                    DropdownButtonFormField<String>(
                      value: sex,
                      decoration: const InputDecoration(labelText: 'Sexo'),
                      items: sexOptions.entries.map((entry) {
                        return DropdownMenuItem<String>(
                          value: entry.value,
                          child: Text(entry.key),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          sex = value!;
                        });
                      },
                    ),
                    TextField(
                      decoration: const InputDecoration(labelText: 'Raça'),
                      controller: raceController,
                    ),
                    DropdownButtonFormField<AnimalType>(
                      value: selectedAnimalType,
                      decoration:
                          const InputDecoration(labelText: 'Tipo de Animal'),
                      items: typeItems,
                      onChanged: (value) {
                        setState(() {
                          selectedAnimalType = value;
                        });
                      },
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedCollaboratorId,
                      decoration:
                          const InputDecoration(labelText: 'Colaborador'),
                      items: colaboradores.map((collaborator) {
                        return DropdownMenuItem<String>(
                          value: collaborator.id,
                          child: Text(collaborator.name ?? 'Desconhecido'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCollaboratorId = value;
                          updateHomes(colaboradores.firstWhere(
                              (collaborator) => collaborator.id == value,
                              orElse: () => Usuario()));
                        });
                      },
                    ),
                    if (selectedCollaboratorId != null)
                      DropdownButtonFormField<String>(
                        value: selectedHomeId,
                        decoration:
                            const InputDecoration(labelText: 'Endereço'),
                        items: homeItems,
                        onChanged: (value) {
                          setState(() {
                            selectedHomeId = value;
                          });
                        },
                      ),
                    SwitchListTile(
                      title: const Text('Castrado'),
                      value: castrated,
                      onChanged: (value) {
                        setState(() {
                          castrated = value;
                        });
                      },
                    ),
                    SwitchListTile(
                      title: const Text('Status'),
                      value: status,
                      onChanged: (value) {
                        setState(() {
                          status = value;
                        });
                      },
                    ),
                    TextField(
                      decoration: const InputDecoration(
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
            ),
            actions: [
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                child: const Text('Salvar'),
                onPressed: () async {
                  try {
                    final updatedAnimal = Animal(
                      id: animal.id,
                      name: nameController.text,
                      description: descriptionController.text,
                      sex: sex,
                      castrated: castrated,
                      race: raceController.text,
                      linkPhoto: 'linkPhoto',
                      typeAnimalId: selectedAnimalType!.id,
                      status: status,
                      createdAt: animal.createdAt,
                      dateExit: status
                          ? DateTime(0000, 1, 1).toUtc().toIso8601String()
                          : DateTime.now().toUtc().toIso8601String(),
                      home: selectedHomeId != null
                          ? Home(id: selectedHomeId)
                          : null,
                    );

                    await animalRepository.updateAnimal(updatedAnimal);

                    if (initialStatus != status) {
                      TopSnackBar.show(
                        context,
                        status ? 'Animal ativado' : 'Animal desativado',
                        status ? true : false,
                      );
                    } else {
                      TopSnackBar.show(
                        context,
                        'Animal atualizado com sucesso',
                        true,
                      );
                    }

                    Navigator.of(context).pop();
                    onAnimalUpdated();
                  } catch (e) {
                    if (e is DioException && e.response!.statusCode != 498) {
                      log(e.toString());
                      TopSnackBar.show(
                          context, 'Erro ao atualizar animal', false);
                    } else {
                      rethrow;
                    }
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
