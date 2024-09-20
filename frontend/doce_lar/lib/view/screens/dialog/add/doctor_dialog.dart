import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:doce_lar/controller/cep.dart';
import 'package:doce_lar/controller/interceptor_dio.dart';
import 'package:doce_lar/controller/login_controller.dart';
import 'package:doce_lar/model/models/doctor_model.dart';
import 'package:doce_lar/model/repositories/doctor_repository.dart';
import 'package:doce_lar/view/widgets/feedback_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:provider/provider.dart';

Future<void> showAddDoctorDialog(BuildContext context, Function() callback) async {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController crmvController = TextEditingController();
  final TextEditingController expertiseController = TextEditingController();
  final TextEditingController phoneController =
      MaskedTextController(mask: '(00) 00000-0000');
  final TextEditingController socialReasonController = TextEditingController();
  final TextEditingController cepController =
      MaskedTextController(mask: '00000-000');
  final TextEditingController stateController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController openHoursController = TextEditingController();

   final loginProvider = Provider.of<LoginController>(context, listen: false);
  final customDio = CustomDio(loginProvider, context);
  final doctorRepository = DoctorRepository(customDio);

  bool isLoading = false; // Variável de estado para carregamento

  Future<void> buscarCep(String cep, Function(void Function()) setState) async {
    String cepSemHifen = cep.replaceAll('-', '');

    if (cepSemHifen.length == 8) {
      final endereco = await CepService().buscarEnderecoPorCep(cepSemHifen);
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
  }

  await showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Adicionar Novo Médico'),
            content: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Campos do formulário
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Nome do Médico'),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                      ],
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Campo obrigatório' : null,
                    ),
                    TextFormField(
                      controller: crmvController,
                      decoration: const InputDecoration(labelText: 'CRMV'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Campo obrigatório' : null,
                    ),
                    TextFormField(
                      controller: expertiseController,
                      decoration: const InputDecoration(labelText: 'Especialidade'),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                      ],
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Campo obrigatório' : null,
                    ),
                    TextFormField(
                      controller: phoneController,
                      decoration: const InputDecoration(labelText: 'Telefone'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Campo obrigatório' : null,
                    ),
                    TextFormField(
                      controller: socialReasonController,
                      decoration: const InputDecoration(labelText: 'Razão Social'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Campo obrigatório' : null,
                    ),
                    TextFormField(
                      controller: cepController,
                      decoration: const InputDecoration(labelText: 'CEP'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Campo obrigatório' : null,
                      onChanged: (value) {
                        buscarCep(value, setState);
                      },
                    ),
                    TextFormField(
                      controller: stateController,
                      decoration: const InputDecoration(labelText: 'Estado'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Campo obrigatório' : null,
                    ),
                    TextFormField(
                      controller: cityController,
                      decoration: const InputDecoration(labelText: 'Cidade'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Campo obrigatório' : null,
                    ),
                    TextFormField(
                      controller: districtController,
                      decoration: const InputDecoration(labelText: 'Bairro'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Campo obrigatório' : null,
                    ),
                    TextFormField(
                      controller: addressController,
                      decoration: const InputDecoration(labelText: 'Endereço'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Campo obrigatório' : null,
                    ),
                    TextFormField(
                      controller: numberController,
                      decoration: const InputDecoration(labelText: 'Número'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Campo obrigatório' : null,
                    ),
                    TextFormField(
                      controller: openHoursController,
                      decoration: const InputDecoration(labelText: 'Horário de Funcionamento'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Campo obrigatório' : null,
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
                  : ElevatedButton(
                      onPressed: isLoading // Desabilita botão enquanto está carregando
                          ? null
                          : () async {
                              if (formKey.currentState?.validate() ?? false) {
                                setState(() {
                                  isLoading = true; // Inicia o carregamento
                                });

                                final newDoctor = Doctor(
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
                                  status: true,
                                );

                                try {
                                  await doctorRepository.addDoctor(newDoctor);
                                  callback();
                                  Navigator.of(context).pop();
                                  TopSnackBar.show(context, 'Médico adicionado com sucesso!', true);
                               } catch (e) {
                                  if (e is DioException && e.response!.statusCode != 498) {
                                    log(e.toString());
                                    TopSnackBar.show(context,
                                        'Erro ao adicionar médico', false);
                                  } else {
                                    rethrow;
                                  }
                                } finally {
                                  setState(() {
                                    isLoading = false; // Finaliza o carregamento
                                  });
                                }
                              }
                            },
                      child: const Text('Adicionar'),
                    ),
            ],
          );
        },
      );
    },
  );
}
