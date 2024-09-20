import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:doce_lar/controller/cep.dart';
import 'package:doce_lar/controller/interceptor_dio.dart';
import 'package:doce_lar/controller/login_controller.dart';
import 'package:doce_lar/model/models/doctor_model.dart';
import 'package:doce_lar/model/models/service_model.dart';
import 'package:doce_lar/model/repositories/doctor_repository.dart';
import 'package:doce_lar/model/repositories/service_repository.dart';
import 'package:doce_lar/view/screens/dialog/details/service_details_screen.dart';
import 'package:doce_lar/view/widgets/detail_row.dart';
import 'package:doce_lar/view/widgets/feedback_snackbar.dart';
import 'package:doce_lar/view/widgets/format_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:provider/provider.dart';

Future<void> showDoctorDetailDialog(
    BuildContext context, Doctor doctor, Function() onDoctorUpdated) async {
  await showDialog(
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
                child: const TabBar(
                  tabs: [
                    Tab(text: 'Detalhes'),
                    Tab(text: 'Serviços'),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 500,
                  child: TabBarView(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            Center(
                              child: Text(doctor.name ?? 'N/A',
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold)),
                            ),
                            DetailRow(label: 'CRMV', value: doctor.crmv),
                            DetailRow(
                                label: 'Especialidade',
                                value: doctor.expertise),
                            DetailRow(label: 'Telefone', value: doctor.phone),
                            DetailRow(
                                label: 'Razão Social',
                                value: doctor.socialReason),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Endereço',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 5),
                                  Container(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      '${doctor.address}, ${doctor.number}, ${doctor.district}, ${doctor.city} - ${doctor.state} - ${doctor.cep}',
                                      style: TextStyle(color: Colors.grey[700]),
                                      textAlign: TextAlign.left,
                                      softWrap: true,
                                    ),
                                  ),
                                  const Divider(),
                                ],
                              ),
                            ),
                            DetailRow(
                                label: 'Horário de Funcionamento',
                                value: doctor.openHours),
                            DetailRow(
                                label: 'Status',
                                value: doctor.status != null
                                    ? (doctor.status! ? 'Ativo' : 'Inativo')
                                    : ''),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    await _showEditDoctorDialog(
                                        context, doctor, onDoctorUpdated);
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Editar'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      FutureBuilder<List<Service>>(
                        future: _fetchServicesForDoctor(
                            doctor.services?.map((s) => s.id ?? '').toList() ??
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
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(service.animal!.name!),
                                                    if (service.procedures !=
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
                                                      context, service.id!, () {
                                                    Navigator.of(context).pop();
                                                    onDoctorUpdated();
                                                  });
                                                },
                                              ),
                                              const Divider()
                                            ],
                                          );
                                        },
                                      ),
                                    )
                                  : const Center(
                                      child: Text(
                                          'Nenhum serviço encontrado para este médico.')),
                              const SizedBox(height: 20),
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
                      child: const Text('Fechar'),
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

Future<List<Service>> _fetchServicesForDoctor(
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

  return services;
}

Future<Map<String, String>?> _buscarCep(String cep) async {
  try {
    String cepSemHifen = cep.replaceAll('-', '');

    if (cepSemHifen.length == 8) {
      final endereco = await CepService().buscarEnderecoPorCep(cepSemHifen);
      if (endereco != null) {
        return {
          'logradouro': endereco['logradouro'] ?? '',
          'localidade': endereco['localidade'] ?? '',
          'uf': endereco['uf'] ?? '',
          'bairro': endereco['bairro'] ?? '',
        };
      } else {
        return null;
      }
    }
  } catch (e) {
    log('Erro ao buscar CEP: $e');
  }
  return null;
}

Future<void> _showEditDoctorDialog(
    BuildContext context, Doctor doctor, Function() onDoctorUpdated) async {
  final TextEditingController nameController =
      TextEditingController(text: doctor.name ?? '');
  final TextEditingController crmvController =
      TextEditingController(text: doctor.crmv ?? '');
  final TextEditingController expertiseController =
      TextEditingController(text: doctor.expertise ?? '');
  final TextEditingController phoneController =
      TextEditingController(text: doctor.phone ?? '');
  final TextEditingController socialReasonController =
      TextEditingController(text: doctor.socialReason ?? '');
  final TextEditingController cepController =
      MaskedTextController(mask: '00000-000', text: doctor.cep ?? '');
  final TextEditingController stateController =
      TextEditingController(text: doctor.state ?? '');
  final TextEditingController cityController =
      TextEditingController(text: doctor.city ?? '');
  final TextEditingController districtController =
      TextEditingController(text: doctor.district ?? '');
  final TextEditingController addressController =
      TextEditingController(text: doctor.address ?? '');
  final TextEditingController numberController =
      TextEditingController(text: doctor.number ?? '');
  final TextEditingController openHoursController =
      TextEditingController(text: doctor.openHours ?? '');

  bool status = doctor.status!;
  bool initialStatus = status;

  final loginProvider = Provider.of<LoginController>(context, listen: false);
  final customDio = CustomDio(loginProvider, context);
  final doctorRepository = DoctorRepository(customDio);

  await showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          cepController.addListener(() async {
            String cep = cepController.text.replaceAll('-', '');
            if (cep.length == 8) {
              final endereco = await _buscarCep(cep);
              if (endereco != null) {
                setState(() {
                  addressController.text = endereco['logradouro'] ?? '';
                  cityController.text = endereco['localidade'] ?? '';
                  stateController.text = endereco['uf'] ?? '';
                  districtController.text = endereco['bairro'] ?? '';
                });
              } else {
                TopSnackBar.show(context, 'CEP não encontrado', false);
              }
            }
          });

          return AlertDialog(
            title: const Text('Editar Médico'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(labelText: 'Nome'),
                    controller: nameController,
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: 'CRM'),
                    controller: crmvController,
                  ),
                  TextField(
                    decoration:
                        const InputDecoration(labelText: 'Especialidade'),
                    controller: expertiseController,
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Telefone'),
                    controller: phoneController,
                  ),
                  TextField(
                    decoration:
                        const InputDecoration(labelText: 'Razão Social'),
                    controller: socialReasonController,
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: 'CEP'),
                    controller: cepController,
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Estado'),
                    controller: stateController,
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Cidade'),
                    controller: cityController,
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Bairro'),
                    controller: districtController,
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Endereço'),
                    controller: addressController,
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Número'),
                    controller: numberController,
                  ),
                  TextField(
                    decoration: const InputDecoration(
                        labelText: 'Horário de Funcionamento'),
                    controller: openHoursController,
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
                ],
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
                    final updatedDoctor = Doctor(
                      id: doctor.id,
                      name: nameController.text,
                      crmv: crmvController.text,
                      expertise: expertiseController.text,
                      phone: phoneController.text,
                      socialReason: socialReasonController.text,
                      cep: cepController.text,
                      state: stateController.text,
                      city: cityController.text,
                      district: districtController.text,
                      address: addressController.text,
                      number: numberController.text,
                      openHours: openHoursController.text,
                      status: status,
                    );

                    await doctorRepository.updateDoctor(updatedDoctor);
                    if (initialStatus != status) {
                      TopSnackBar.show(
                        context,
                        status ? 'Médico ativado' : 'Médico desativado',
                        status ? true : false,
                      );
                    } else {
                      TopSnackBar.show(
                        context,
                        'Médico atualizado com sucesso',
                        true,
                      );
                    }
                    Navigator.of(context).pop(); // Fechar o diálogo de edição
                    onDoctorUpdated(); // Atualizar a tela principal
                  } catch (e) {
                    if (e is DioException && e.response!.statusCode != 498) {
                      log(e.toString());
                      TopSnackBar.show(
                          context, 'Erro ao atualizar médico', false);
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
