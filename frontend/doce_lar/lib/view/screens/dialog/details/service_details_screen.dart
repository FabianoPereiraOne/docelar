import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:doce_lar/controller/interceptor_dio.dart';
import 'package:doce_lar/controller/login_controller.dart';
import 'package:doce_lar/model/models/doctor_model.dart';
import 'package:doce_lar/model/models/document_model.dart';
import 'package:doce_lar/model/models/procedure_model.dart';
import 'package:doce_lar/model/models/service_model.dart';
import 'package:doce_lar/model/repositories/doctor_repository.dart';
import 'package:doce_lar/model/repositories/procedure_repository.dart';
import 'package:doce_lar/model/repositories/service_repository.dart';
import 'package:doce_lar/model/repositories/upload_repository.dart';
import 'package:doce_lar/view/widgets/confirm_delete.dart';
import 'package:doce_lar/view/widgets/detail_row.dart';
import 'package:doce_lar/view/widgets/feedback_snackbar.dart';
import 'package:doce_lar/view/widgets/format_date.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';

Future<void> showServiceDetailsDialog(
    BuildContext context, String serviceId, Function() onServiceUpdated) async {
  final loginProvider = Provider.of<LoginController>(context, listen: false);
  final customDio = CustomDio(loginProvider, context);
  final serviceRepository = ServiceRepository(customDio);
  Service? service;

  showDialog(
    context: context,
    builder: (context) => const Center(child: CircularProgressIndicator()),
  );

  try {
    service = await serviceRepository.getServiceById(serviceId);
    Navigator.of(context).pop();
  } catch (e) {
    Navigator.of(context).pop();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Erro'),
        content: const Text('Não foi possível carregar os detalhes do serviço.'),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
    return;
  }

  String buildNamesList(List<dynamic> items, String Function(dynamic) getName) {
    return items.isEmpty
        ? 'N/A'
        : items.map((item) => getName(item)).join(', ');
  }

  await showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop(); // Fechar o diálogo
                      },
                    ),
                  ],
                ),
                Text(
                  service!.animal!.name!,
                  maxLines: null,
                  overflow: TextOverflow.visible,
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  DetailRow(
                      label: 'Data de Criação',
                      value: formatDate(service.createdAt!)),
                  DetailRow(
                      label: 'Médicos',
                      value: buildNamesList(
                          service.doctors!, (doctor) => doctor.name)),
                  DetailRow(
                      label: 'Procedimentos',
                      value: buildNamesList(
                          service.procedures!, (procedure) => procedure.name)),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Descrição',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          width: 300,
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1.0),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Text(
                            service.description!,
                            style: TextStyle(color: Colors.grey[700]),
                            textAlign: TextAlign.left,
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20), // Espaçamento
                  const Text(
                    'Fotos',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  // Aqui você adiciona a exibição de fotos
                  FutureBuilder<List<Document>>(
                    future: _fetchUploadedDocuments(context), // Método para buscar fotos
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return const Center(child: Text('Erro ao carregar fotos'));
                      }

                      final photos = snapshot.data;

                      if (photos == null || photos.isEmpty) {
                        return const Center(child: Text('Nenhuma foto encontrada.'));
                      }

                      return Column(
                        children: photos.map((photo) {
                          final imageUrl = 'http://patrick.vps-kinghost.net:7001${photo.key}'; // Ajuste a URL conforme necessário
                          return GestureDetector(
                            onTap: () {
                              // Exibir imagem em tela cheia
                              showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (_) => Dialog(
                                  backgroundColor: Colors.transparent,
                                  child: Stack(
                                    children: [
                                      PhotoView(
                                        imageProvider: NetworkImage(imageUrl),
                                        minScale: PhotoViewComputedScale.contained,
                                        maxScale: PhotoViewComputedScale.covered * 2,
                                        heroAttributes: PhotoViewHeroAttributes(tag: imageUrl),
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
                                            Navigator.of(context).pop(); // Fecha o diálogo
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
                              height: 100, // Altura da imagem na lista
                              fit: BoxFit.cover,
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  await showDeleteDialog(context, serviceId, 'services',
                      'Serviço', onServiceUpdated);

                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Deletar'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _showEditServiceDialog(
                      context, service!, onServiceUpdated);
                  Navigator.of(context).pop();
                },
                child: const Text('Editar'),
              ),
            ],
          );
        },
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

Future<void> showDeleteDialog(
  BuildContext context,
  String itemId,
  String route,
  String entityType,
  Function() onDeleted,
) async {
  await showDialog(
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

Future<void> _showEditServiceDialog(
    BuildContext context, Service service, Function() onServiceUpdated) async {
  final TextEditingController descriptionController =
      TextEditingController(text: service.description ?? '');
  List<Doctor> doctors = [];
  List<Procedure> procedures = [];
  Doctor? selectedDoctor;
  Procedure? selectedProcedure;
  final loginProvider = Provider.of<LoginController>(context, listen: false);
  final customDio = CustomDio(loginProvider, context);
  final doctorRepository = DoctorRepository(customDio);
  final procedureRepository = ProcedureRepository(customDio);
  final serviceRepository = ServiceRepository(customDio);

  Future<void> loadOptions() async {
    doctors = await doctorRepository.fetchDoctors();
    procedures = await procedureRepository.fetchProcedures();
    selectedDoctor = doctors.firstWhere(
        (doc) => doc.id == service.doctors!.first.id,
        orElse: () => doctors.first);
    selectedProcedure = procedures.firstWhere(
        (proc) => proc.id == service.procedures!.first.id,
        orElse: () => procedures.first);
  }

  Future<void> saveService(BuildContext dialogContext) async {
    if (selectedDoctor == null || selectedProcedure == null) {
      log('Erro: Médico ou Procedimento não selecionado corretamente');
      return;
    }
    try {
      final updatedService = Service(
        id: service.id,
        description: descriptionController.text,
        doctors: [selectedDoctor!],
        procedures: [selectedProcedure!],
      );

      await serviceRepository.updateService(updatedService);
      TopSnackBar.show(
        dialogContext,
        'Serviço atualizado com sucesso',
        true,
      );
      Navigator.of(dialogContext).pop();
      onServiceUpdated();
    } catch (e) {
      if (e is DioException && e.response!.statusCode != 498) {
        log(e.toString());
        TopSnackBar.show(dialogContext, 'Erro ao atualizar serviço', false);
      } else {
        rethrow;
      }
    }
  }

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return FutureBuilder(
        future: loadOptions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const AlertDialog(
              title: Text('Carregando'),
              content: CircularProgressIndicator(),
            );
          }

          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text('Editar Serviço'),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButtonFormField<Doctor>(
                        value: selectedDoctor,
                        decoration: InputDecoration(
                          labelText: 'Selecionar Médico',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        items: doctors.map((doctor) {
                          return DropdownMenuItem<Doctor>(
                            value: doctor,
                            child: Text(doctor.name ?? 'Médico ${doctor.id}'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedDoctor = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Por favor, selecione um médico';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<Procedure>(
                        value: selectedProcedure,
                        decoration: InputDecoration(
                          labelText: 'Selecionar Procedimento',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        items: procedures.map((procedure) {
                          return DropdownMenuItem<Procedure>(
                            value: procedure,
                            child: Text(procedure.name ??
                                'Procedimento ${procedure.id}'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedProcedure = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Por favor, selecione um procedimento';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: descriptionController,
                        decoration:
                            const InputDecoration(labelText: 'Descrição'),
                        maxLines: 5,
                        minLines: 3,
                        keyboardType: TextInputType.multiline,
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancelar'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await saveService(context);
                    },
                    child: const Text('Salvar'),
                  ),
                ],
              );
            },
          );
        },
      );
    },
  );
}