import 'package:doce_lar/controller/cep.dart';
import 'package:doce_lar/controller/login_controller.dart';
import 'package:doce_lar/model/models/doctor_model.dart';
import 'package:doce_lar/model/models/service_model.dart';
import 'package:doce_lar/model/repositories/doctor_repository.dart';
import 'package:doce_lar/model/repositories/service_repository.dart';
import 'package:doce_lar/view/screens/dialog/details/service_details_screen.dart';
import 'package:doce_lar/view/widgets/format_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:provider/provider.dart';

void showDoctorDetailDialog(
    BuildContext context, Doctor doctor, Function() onDoctorUpdated) async {
  final loginProvider = Provider.of<LoginController>(context, listen: false);

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
                            _buildDetailRow('Nome', doctor.name),
                            _buildDetailRow('CRM', doctor.crmv),
                            _buildDetailRow('Especialidade', doctor.expertise),
                            _buildDetailRow('Telefone', doctor.phone),
                            _buildDetailRow(
                                'Razão Social', doctor.socialReason),
                            _buildDetailRow('CEP', doctor.cep),
                            _buildDetailRow('Estado', doctor.state),
                            _buildDetailRow('Cidade', doctor.city),
                            _buildDetailRow('Bairro', doctor.district),
                            _buildDetailRow('Endereço', doctor.address),
                            _buildDetailRow('Número', doctor.number),
                            _buildDetailRow(
                                'Horário de Funcionamento', doctor.openHours),
                            _buildDetailRow('Status',
                                doctor.status == true ? 'Ativo' : 'Inativo'),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    _showEditDoctorDialog(
                                        context, doctor, onDoctorUpdated);
                                  },
                                  child: Text('Editar'),
                                ),
                                // ElevatedButton(
                                //   onPressed: () {
                                //     Navigator.of(context).pop();
                                //     _confirmDeleteDoctor(context, doctor.id!, onDoctorUpdated);
                                //   },
                                //   child: Text('Deletar'),
                                //   style: TextButton.styleFrom(foregroundColor: Colors.red),
                                // ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      FutureBuilder<List<Service>>(
                        future: _fetchServicesForDoctor(doctor.services?.map((s) => s.id ?? '').toList() ?? [], loginProvider.token),
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
                                                Text(service.animal!.name! ),
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
                                                onDoctorUpdated();
                                              });
                                            },
                                          );
                                        },
                                      ),
                                    )
                                  : Center(
                                      child: Text('Nenhum serviço encontrado para este médico.')),
                              SizedBox(height: 20),
                              
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


Future<List<Service>> _fetchServicesForDoctor(
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

  return services;
}

void _confirmDeleteDoctor(
    BuildContext context, String doctorId, Function() onDoctorDeleted) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Confirmar Exclusão'),
      content: Text('Tem certeza que deseja excluir este médico?'),
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
            final doctorRepository = DoctorRepository();

            try {
              await doctorRepository.deleteDoctor(
                  doctorId, loginProvider.token);
              Navigator.of(context).pop(); // Fechar o diálogo de confirmação
              onDoctorDeleted(); // Atualizar a tela principal
            } catch (e) {
              print('Erro ao excluir médico: $e');
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
    print('Erro ao buscar CEP: $e');
  }
  return null;
}

void _showEditDoctorDialog(BuildContext context, Doctor doctor, Function() onDoctorUpdated) {
  final TextEditingController nameController = TextEditingController(text: doctor.name ?? '');
  final TextEditingController crmvController = TextEditingController(text: doctor.crmv ?? '');
  final TextEditingController expertiseController = TextEditingController(text: doctor.expertise ?? '');
  final TextEditingController phoneController = TextEditingController(text: doctor.phone ?? '');
  final TextEditingController socialReasonController = TextEditingController(text: doctor.socialReason ?? '');
  final TextEditingController cepController = MaskedTextController(mask: '00000-000', text: doctor.cep ?? '');
  final TextEditingController stateController = TextEditingController(text: doctor.state ?? '');
  final TextEditingController cityController = TextEditingController(text: doctor.city ?? '');
  final TextEditingController districtController = TextEditingController(text: doctor.district ?? '');
  final TextEditingController addressController = TextEditingController(text: doctor.address ?? '');
  final TextEditingController numberController = TextEditingController(text: doctor.number ?? '');
  final TextEditingController openHoursController = TextEditingController(text: doctor.openHours ?? '');

  bool status = doctor.status ?? true;

  showDialog(
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
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('CEP inválido ou não encontrado')),
                );
              }
            }
          });

          return AlertDialog(
            title: Text('Editar Médico'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: InputDecoration(labelText: 'Nome'),
                    controller: nameController,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'CRM'),
                    controller: crmvController,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Especialidade'),
                    controller: expertiseController,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Telefone'),
                    controller: phoneController,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Razão Social'),
                    controller: socialReasonController,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'CEP'),
                    controller: cepController,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Estado'),
                    controller: stateController,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Cidade'),
                    controller: cityController,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Bairro'),
                    controller: districtController,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Endereço'),
                    controller: addressController,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Número'),
                    controller: numberController,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Horário de Funcionamento'),
                    controller: openHoursController,
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
                  final loginProvider = Provider.of<LoginController>(context, listen: false);
                  final doctorRepository = DoctorRepository();

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

                    await doctorRepository.updateDoctor(updatedDoctor, loginProvider.token);

                    Navigator.of(context).pop(); // Fechar o diálogo de edição
                    onDoctorUpdated(); // Atualizar a tela principal
                  } catch (e) {
                    print('Erro ao editar médico: $e');
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
