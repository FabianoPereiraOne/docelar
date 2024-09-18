import 'dart:developer';
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

void showServiceDialog(
    BuildContext context, String animalId, Function() callback) {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController descriptionController = TextEditingController();

  final loginProvider = Provider.of<LoginController>(context, listen: false);

  Doctor? selectedDoctor;
  Procedure? selectedProcedure;

  List<Doctor> doctors = [];
  List<Procedure> procedures = [];

  Future<void> loadOptions() async {
    final doctorRepository = DoctorRepository();
    final procedureRepository = ProcedureRepository();

    doctors = await doctorRepository.fetchDoctors(loginProvider.token);

    doctors = doctors.where((doctor) => doctor.status == true).toList();

    procedures = await procedureRepository.fetchProcedures(loginProvider.token);
    log(procedures.toString());
  }

  Future<void> saveService(BuildContext dialogContext) async {
    if (formKey.currentState?.validate() ?? false) {
      final String? doctorId = selectedDoctor?.id;
      final int? procedureId = selectedProcedure?.id;

      if (doctorId == null || procedureId == null) {
        log('Erro: Médico ou Procedimento não selecionado corretamente');
        return;
      }

      final newService = Service(
        description: descriptionController.text,
        animal: Animal(id: animalId),
        doctors: [Doctor(id: doctorId)],
        procedures: [Procedure(id: procedureId)],
      );

      final serviceRepository = ServiceRepository();
      await serviceRepository.addService(newService, loginProvider.token);

      TopSnackBar.show(dialogContext, 'Serviço adicionado com sucesso', true);

      Navigator.of(dialogContext).pop();

      callback();
    } else {
      TopSnackBar.show(context, 'Erro ao adicionar serviço', false);
    }
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
                          child: Text(
                              procedure.name ?? 'Procedimento ${procedure.id}'),
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
                onPressed: () async {
                  if (formKey.currentState?.validate() ?? false) {
                    await saveService(context);
                  } else {
                    log('Formulário inválido');
                  }
                },
                child: const Text('Salvar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancelar'),
              ),
            ],
          );
        },
      );
    },
  );
}
