import 'dart:developer';

import 'package:doce_lar/model/models/animal_model.dart';
import 'package:doce_lar/model/repositories/doctor_repository.dart';
import 'package:doce_lar/model/repositories/procedure_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doce_lar/model/models/service_model.dart';
import 'package:doce_lar/model/repositories/service_repository.dart';
import 'package:doce_lar/controller/login_controller.dart';
import 'package:doce_lar/model/models/doctor_model.dart';
import 'package:doce_lar/model/models/procedure_model.dart';

void showServiceDialog(
    BuildContext context, String animalId, Function() callback) {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();

  final loginProvider = Provider.of<LoginController>(context, listen: false);

  // Para armazenar os médicos, procedimentos e status selecionados
  Doctor? _selectedDoctor;
  Procedure? _selectedProcedure;
  String? _selectedStatus; // Novo campo para armazenar o status selecionado

  // Para armazenar as listas de médicos e procedimentos
  List<Doctor> _doctors = [];
  List<Procedure> _procedures = [];

  Future<void> _loadOptions() async {
    // Carregue os médicos e procedimentos do repositório
    final doctorRepository = DoctorRepository();
    final procedureRepository = ProcedureRepository();

    _doctors = await doctorRepository.fetchDoctors(loginProvider.token);
    _procedures =
        await procedureRepository.fetchProcedures(loginProvider.token);
    log(_procedures.toString());
  }
  
Future<void> _saveService() async {
  if (_formKey.currentState?.validate() ?? false) {
    // Capturar os IDs de médico e procedimento
    final String? doctorId = _selectedDoctor?.id;
    final int? procedureId = _selectedProcedure?.id;

    if (doctorId == null || procedureId == null || _selectedStatus == null) {
      // Exibir mensagem de erro se o ID ou status não for selecionado corretamente
      log('Erro: Médico, Procedimento ou Status não selecionado corretamente');
      return;
    }

    // Log para verificar o valor de _selectedStatus
    log('Status selecionado: $_selectedStatus');

    // Converter o status selecionado para booleano
    final bool status = _selectedStatus == 'Concluído' ? true : false;

    // Log para verificar o valor booleano de status
    log('Status convertido para booleano: $status');

    final newService = Service(
      description: _descriptionController.text,
      status: status, 
      animal: Animal(id: animalId), 
      doctors: [Doctor(id: doctorId)], 
      procedures: [Procedure(id: procedureId)],
    );

    // Log do objeto newService para verificar os dados antes de salvar
    log('Novo serviço a ser salvo: ${newService.toString()}');

    final serviceRepository = ServiceRepository();
    await serviceRepository.addService(newService, loginProvider.token);

    // Log após a tentativa de salvar o serviço
    log('Serviço salvo com sucesso');

    callback();
  } else {
    log('Formulário inválido');
  }
}

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return FutureBuilder(
        future: _loadOptions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return AlertDialog(
              title: Text('Carregando'),
              content: CircularProgressIndicator(),
            );
          }

          return AlertDialog(
            title: Text('Adicionar Serviço'),
            content: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<Doctor>(
                      value: _selectedDoctor,
                      decoration: InputDecoration(
                        labelText: 'Selecionar Médico',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      items: _doctors.map((doctor) {
                        return DropdownMenuItem<Doctor>(
                          value: doctor,
                          child: Text(doctor.name ?? 'Médico ${doctor.id}'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        _selectedDoctor = value;
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Por favor, selecione um médico';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    DropdownButtonFormField<Procedure>(
                      value: _selectedProcedure,
                      decoration: InputDecoration(
                        labelText: 'Selecionar Procedimento',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      items: _procedures.map((procedure) {
                        return DropdownMenuItem<Procedure>(
                          value: procedure,
                          child: Text(
                              procedure.name ?? 'Procedimento ${procedure.id}'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        _selectedProcedure = value;
                        log(_selectedProcedure!.name!);
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Por favor, selecione um procedimento';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: _selectedStatus,
                      decoration: InputDecoration(
                        labelText: 'Selecionar Status',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: 'Em andamento',
                          child: Text('Em andamento'),
                        ),
                        DropdownMenuItem(
                          value: 'Concluído',
                          child: Text('Concluído'),
                        ),
                      ],
                      onChanged: (value) {
                        _selectedStatus = value;
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Por favor, selecione um status';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 5,
                      minLines: 3,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
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
                  await _saveService();
                  Navigator.of(context).pop();
                },
                child: Text('Salvar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancelar'),
              ),
            ],
          );
        },
      );
    },
  );
}
