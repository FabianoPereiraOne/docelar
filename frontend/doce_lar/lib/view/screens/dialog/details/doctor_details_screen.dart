import 'package:doce_lar/controller/login_controller.dart';
import 'package:doce_lar/model/models/doctor_model.dart';
import 'package:doce_lar/model/repositories/doctor_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void showDoctorDetailDialog(BuildContext context, Doctor doctor, Function() onDoctorUpdated) async {


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
                    Tab(text: 'Serviços'), // Abas para serviços ainda não implementadas
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 300,
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
                            _buildDetailRow('Razão Social', doctor.socialReason),
                            _buildDetailRow('CEP', doctor.cep),
                            _buildDetailRow('Estado', doctor.state),
                            _buildDetailRow('Cidade', doctor.city),
                            _buildDetailRow('Bairro', doctor.district),
                            _buildDetailRow('Endereço', doctor.address),
                            _buildDetailRow('Número', doctor.number),
                            _buildDetailRow('Horário de Funcionamento', doctor.openHours),
                            _buildDetailRow('Status', doctor.status == true ? 'Ativo' : 'Inativo'),
                          ],
                        ),
                      ),
                      Center(
                        child: Text('Serviços ainda não implementados.'),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Fechar'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _showEditDoctorDialog(context, doctor, onDoctorUpdated);
                    },
                    child: Text('Editar'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _confirmDeleteDoctor(context, doctor.id!, onDoctorUpdated);
                    },
                    child: Text('Deletar'),
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

void _confirmDeleteDoctor(BuildContext context, String doctorId, Function() onDoctorDeleted) {
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
            final loginProvider = Provider.of<LoginController>(context, listen: false);
            final doctorRepository = DoctorRepository();

            try {
              await doctorRepository.deleteDoctor(doctorId, loginProvider.token);
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

void _showEditDoctorDialog(BuildContext context, Doctor doctor, Function() onDoctorUpdated) {
  final TextEditingController nameController = TextEditingController(text: doctor.name ?? '');
  final TextEditingController crmvController = TextEditingController(text: doctor.crmv ?? '');
  final TextEditingController expertiseController = TextEditingController(text: doctor.expertise ?? '');
  final TextEditingController phoneController = TextEditingController(text: doctor.phone ?? '');
  final TextEditingController socialReasonController = TextEditingController(text: doctor.socialReason ?? '');
  final TextEditingController cepController = TextEditingController(text: doctor.cep ?? '');
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
