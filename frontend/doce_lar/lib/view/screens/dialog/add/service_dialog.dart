import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:doce_lar/controller/interceptor_dio.dart';
import 'package:doce_lar/model/models/animal_model.dart';
import 'package:doce_lar/model/repositories/doctor_repository.dart';
import 'package:doce_lar/model/repositories/procedure_repository.dart';
import 'package:doce_lar/view/widgets/feedback_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doce_lar/model/models/service_model.dart';
import 'package:doce_lar/model/repositories/service_repository.dart';
import 'package:doce_lar/controller/login_controller.dart';
import 'package:doce_lar/model/models/doctor_model.dart';
import 'package:doce_lar/model/models/procedure_model.dart';

Future<void> showServiceDialog(
    BuildContext context, String animalId, Function() callback) async {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController descriptionController = TextEditingController();

  final loginProvider = Provider.of<LoginController>(context, listen: false);
  final customDio = CustomDio(loginProvider, context);
  final doctorRepository = DoctorRepository(customDio);
  final procedureRepository = ProcedureRepository(customDio);
  final serviceRepository = ServiceRepository(customDio);

  Doctor? selectedDoctor;
  Procedure? selectedProcedure;

  List<Doctor> doctors = [];
  List<Procedure> procedures = [];

  bool isLoading = false; // Variável de estado para carregamento

  Future<void> loadOptions() async {
    doctors = await doctorRepository.fetchDoctors();
    doctors = doctors.where((doctor) => doctor.status == true).toList();

    procedures = await procedureRepository.fetchProcedures();
    log(procedures.toString());
  }

  Future<void> saveService(
      BuildContext dialogContext, Function(void Function()) setState) async {
    if (formKey.currentState?.validate() ?? false) {
      setState(() {
        isLoading = true; // Ativando estado de carregamento
      });

      final String? doctorId = selectedDoctor?.id;
      final int? procedureId = selectedProcedure?.id;

      if (doctorId == null || procedureId == null) {
        log('Erro: Médico ou Procedimento não selecionado corretamente');
        setState(() {
          isLoading =
              false; // Desativando estado de carregamento em caso de erro
        });
        return;
      }

      final newService = Service(
        description: descriptionController.text,
        animal: Animal(id: animalId),
        doctors: [Doctor(id: doctorId)],
        procedures: [Procedure(id: procedureId)],
      );
      try {
        await serviceRepository.addService(newService);
        TopSnackBar.show(dialogContext, 'Serviço adicionado com sucesso', true);
        callback();
        Navigator.of(dialogContext).pop();
      } catch (e) {
        if (e is DioException && e.response!.statusCode != 498) {
          log(e.toString());
          TopSnackBar.show(context, 'Erro ao adicionar serviço', false);
        } else {
          rethrow;
        }
      } finally {
        setState(() {
          isLoading =
              false; // Desativando estado de carregamento após a operação
        });
      }
    } else {
      TopSnackBar.show(context, 'Erro ao adicionar serviço', false);
    }
  }

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return FutureBuilder(
            future: loadOptions(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const AlertDialog(
                  title: Text('Carregando'),
                  content: CircularProgressIndicator(),
                );
              }

              return AlertDialog(
                title: const Text('Adicionar Serviço'),
                content: SingleChildScrollView(
                  child: Form(
                    key: formKey,
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
                            selectedDoctor = value;
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
                            selectedProcedure = value;
                            log(selectedProcedure!.name!);
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Por favor, selecione um procedimento';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: descriptionController,
                          maxLines: 5,
                          minLines: 3,
                          keyboardType: TextInputType.multiline,
                          decoration: const InputDecoration(
                            labelText: 'Descrição',
                            border: OutlineInputBorder(),
                            alignLabelWithHint: true,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira uma descrição';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancelar'),
                  ),
                  isLoading // Indicador de carregamento
                      ? const CircularProgressIndicator() // Exibe indicador enquanto carrega
                      : TextButton(
                          onPressed: isLoading
                              ? null // Desabilita o botão enquanto carrega
                              : () async {
                                  if (formKey.currentState?.validate() ??
                                      false) {
                                    await saveService(context, setState);
                                  } else {
                                    log('Formulário inválido');
                                  }
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
