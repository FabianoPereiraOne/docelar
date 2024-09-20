import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:doce_lar/controller/interceptor_dio.dart';
import 'package:doce_lar/model/models/homes_model.dart';
import 'package:doce_lar/model/repositories/homes_repository.dart';
import 'package:doce_lar/view/widgets/feedback_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:doce_lar/controller/cep.dart';
import 'package:doce_lar/controller/login_controller.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:provider/provider.dart';

Future<void> showEnderecoDialog(
    BuildContext context, String colaboradorId, Function() callback) async {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController ruaController = TextEditingController();
  final TextEditingController cidadeController = TextEditingController();
  final TextEditingController estadoController = TextEditingController();
  final TextEditingController cepController =
      MaskedTextController(mask: '00000-000');
  final TextEditingController districtController = TextEditingController();
  final TextEditingController numeroController = TextEditingController();
  final loginProvider = Provider.of<LoginController>(context, listen: false);
  final customDio = CustomDio(loginProvider, context);
  final homeRepository = HomeRepository(customDio);

  bool isLoading = false;

  Future<void> buscarCep(String cep) async {
    String cepSemHifen = cep.replaceAll('-', '');
    if (cepSemHifen.length == 8) {
      try {
        final endereco = await CepService().buscarEnderecoPorCep(cepSemHifen);
        if (endereco != null) {
          ruaController.text = endereco['logradouro'] ?? '';
          cidadeController.text = endereco['localidade'] ?? '';
          estadoController.text = endereco['uf'] ?? '';
          districtController.text = endereco['bairro'] ?? '';
        } else {
          TopSnackBar.show(context, 'CEP inválido ou não encontrado', false);
        }
      } catch (e) {
        TopSnackBar.show(context, 'Erro ao buscar CEP', false);
      }
    }
  }

  Future<bool> addEndereco() async {
    if (formKey.currentState?.validate() ?? false) {
      final newHome = Home(
        cep: cepController.text,
        state: estadoController.text,
        city: cidadeController.text,
        district: districtController.text,
        address: ruaController.text,
        number: numeroController.text,
        status: true,
        collaboratorId: colaboradorId,
      );

      try {
        await homeRepository.addHome(newHome);
        return true;
      } catch (e) {
        if (e is DioException && e.response!.statusCode != 498) {
          log(e.toString());
          TopSnackBar.show(context, 'Erro ao adicionar endereço', false);
        } else {
          rethrow;
        }
      }
    }
    return false;
  }

  void limparControladores() {
    ruaController.clear();
    cidadeController.clear();
    estadoController.clear();
    cepController.clear();
    districtController.clear();
    numeroController.clear();
  }

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Adicionar Endereço'),
            content: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: cepController,
                      decoration: InputDecoration(
                        labelText: 'CEP',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: buscarCep,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira um CEP';
                        } else if (value.length != 9) {
                          return 'O CEP deve ter 8 dígitos';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: estadoController,
                      decoration: InputDecoration(
                        labelText: 'Estado',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira um estado';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: cidadeController,
                      decoration: InputDecoration(
                        labelText: 'Cidade',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira uma cidade';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: districtController,
                      decoration: InputDecoration(
                        labelText: 'Bairro',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira um bairro';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: ruaController,
                      decoration: InputDecoration(
                        labelText: 'Rua',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira uma rua';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: numeroController,
                      decoration: InputDecoration(
                        labelText: 'Número',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira um número';
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
                  limparControladores();
                },
                child: const Text('Fechar'),
              ),
              isLoading // Exibir o indicador de carregamento
                  ? const CircularProgressIndicator()
                  : TextButton(
                      onPressed: () async {
                        setState(() {
                          isLoading = true; // Iniciar o carregamento
                        });

                        bool isSuccess = await addEndereco();

                        setState(() {
                          isLoading = false; // Finalizar o carregamento
                        });

                        if (isSuccess) {
                          TopSnackBar.show(
                            context,
                            'Endereço adicionado com sucesso para o colaborador',
                            true,
                          );
                          callback();
                          Navigator.of(context).pop();
                        } else {
                          log('Erro ao adicionar endereço');
                        }
                      },
                      child: const Text('Concluir'),
                    ),
            ],
          );
        },
      );
    },
  );
}
