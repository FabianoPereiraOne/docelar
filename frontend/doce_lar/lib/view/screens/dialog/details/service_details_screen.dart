import 'dart:developer';

import 'package:doce_lar/controller/login_controller.dart';
import 'package:doce_lar/model/models/doctor_model.dart';
import 'package:doce_lar/model/models/procedure_model.dart';
import 'package:doce_lar/model/models/service_model.dart';
import 'package:doce_lar/model/repositories/doctor_repository.dart';
import 'package:doce_lar/model/repositories/procedure_repository.dart';
import 'package:doce_lar/model/repositories/service_repository.dart';
import 'package:doce_lar/view/widgets/confirm_delete.dart';
import 'package:doce_lar/view/widgets/detail_row.dart';
import 'package:doce_lar/view/widgets/feedback_snackbar.dart';
import 'package:doce_lar/view/widgets/format_date.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void showServiceDetailsDialog(
    BuildContext context, String serviceId, Function() onServiceUpdated) async {
  final loginProvider = Provider.of<LoginController>(context, listen: false);
  final serviceRepository = ServiceRepository();
  Service? service;

  showDialog(
    context: context,
    builder: (context) => const Center(child: CircularProgressIndicator()),
  );

  try {
    service =
        await serviceRepository.getServiceById(serviceId, loginProvider.token);
    Navigator.of(context).pop();
  } catch (e) {
    Navigator.of(context).pop();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Erro'),
        content:
            const Text('Não foi possível carregar os detalhes do serviço.'),
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
  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(service!.animal!.name!),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop(); // Fechar o diálogo
                  },
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
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _showEditServiceDialog(context, service!, onServiceUpdated);
                },
                child: const Text('Editar'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  showDeleteDialog(context, serviceId, 'services', 'Serviço',
                      onServiceUpdated);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Deletar'),
              ),
            ],
          );
        },
      );
    },
  );
}

void showDeleteDialog(
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

void _showEditServiceDialog(
    BuildContext context, Service service, Function() onServiceUpdated) {
  final TextEditingController descriptionController =
      TextEditingController(text: service.description ?? '');
  List<Doctor> doctors = [];
  List<Procedure> procedures = [];
  Doctor? selectedDoctor;
  Procedure? selectedProcedure;
  final loginProvider = Provider.of<LoginController>(context, listen: false);

  Future<void> loadOptions() async {
    final doctorRepository = DoctorRepository();
    final procedureRepository = ProcedureRepository();

    doctors = await doctorRepository.fetchDoctors(loginProvider.token);
    procedures = await procedureRepository.fetchProcedures(loginProvider.token);
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

    final updatedService = Service(
      id: service.id,
      description: descriptionController.text,
      doctors: [selectedDoctor!],
      procedures: [selectedProcedure!],
    );

    final serviceRepository = ServiceRepository();
    await serviceRepository.updateService(updatedService, loginProvider.token);
    TopSnackBar.show(
      dialogContext,
      'Serviço atualizado com sucesso',
      true,
    );
    Navigator.of(dialogContext).pop();
    onServiceUpdated();

  }

  showDialog(
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
