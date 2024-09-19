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

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Adicionar Novo Procedimento'),
            content: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Nome do Procedimento'),
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
                      decoration: InputDecoration(labelText: 'Descrição'),
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
                      decoration: InputDecoration(labelText: 'Dosagem'),
                      onChanged: (value) {
                        dosage = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Dosagem é obrigatória';
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
                child: Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      child: Text('Adicionar'),
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          setState(() {
                            isLoading = true;
                          });

                          final loginProvider = Provider.of<LoginController>(context, listen: false);
                          final procedureRepository = ProcedureRepository();

                          try {
                            final newProcedure = Procedure(
                              name: name,
                              description: description,
                              dosage: dosage,
                            );

                            // Adiciona o novo procedimento
                            await procedureRepository.addProcedure(newProcedure, loginProvider.token);

                            // Atualiza a lista de procedimentos
                            callback();

                            Navigator.of(context).pop();
                            TopSnackBar.show(context, 'Procedimento adicionado com sucesso!', true);
                          } catch (e) {
                            TopSnackBar.show(context, 'Erro ao adicionar procedimento:', false);
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
