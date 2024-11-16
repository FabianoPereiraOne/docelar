import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:doce_lar/controller/interceptor_dio.dart';
import 'package:doce_lar/controller/login_controller.dart';
import 'package:doce_lar/model/models/procedure_model.dart';
import 'package:doce_lar/model/repositories/procedure_repository.dart';
import 'package:doce_lar/view/widgets/feedback_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void showAddProcedureDialog(BuildContext context, Function() callback) {
  final formKey = GlobalKey<FormState>();
  String name = '';
  String description = '';
  String dosage = '';
  bool isLoading = false;

  final loginProvider = Provider.of<LoginController>(context, listen: false);
  final customDio = CustomDio(loginProvider, context);
  final procedureRepository = ProcedureRepository(customDio);

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Adicionar Novo Procedimento'),
            content: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                          labelText: 'Nome do Procedimento'),
                      onChanged: (value) {
                        name = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nome é obrigatório';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Descrição'),
                      onChanged: (value) {
                        description = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Descrição é obrigatória';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Dosagem / Quantidade'),
                      onChanged: (value) {
                        dosage = value;
                      },
                      // validator: (value) {
                      //   if (value == null || value.isEmpty) {
                      //     return 'Dosagem é obrigatória';
                      //   }
                      //   return null;
                      // },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      child: const Text('Adicionar'),
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          setState(() {
                            isLoading = true;
                          });

                          try {
                            final newProcedure = Procedure(
                              name: name,
                              description: description,
                              dosage: dosage,
                            );

                            // Adiciona o novo procedimento
                            await procedureRepository
                                .addProcedure(newProcedure);

                            // Atualiza a lista de procedimentos
                            callback();

                            Navigator.of(context).pop();
                            TopSnackBar.show(context,
                                'Procedimento adicionado com sucesso!', true);
                          } catch (e) {
                            if (e is DioException &&
                                e.response!.statusCode != 498) {
                              log(e.toString());
                              TopSnackBar.show(
                                  context, 'Erro ao adicionar procedimento', false);
                            } else {
                              rethrow;
                            }
                          } finally {
                            setState(() {
                              isLoading = false;
                            });
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
