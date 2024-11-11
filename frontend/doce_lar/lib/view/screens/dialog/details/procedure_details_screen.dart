import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:doce_lar/controller/interceptor_dio.dart';
import 'package:doce_lar/controller/login_controller.dart';
import 'package:doce_lar/model/models/procedure_model.dart';
import 'package:doce_lar/model/repositories/procedure_repository.dart';
import 'package:doce_lar/view/widgets/confirm_delete.dart';
import 'package:doce_lar/view/widgets/detail_row.dart';
import 'package:doce_lar/view/widgets/feedback_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> showProcedureDetailDialog(BuildContext context,
    Procedure procedure, Function() onProcedureUpdated) async {
  await showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(procedure.name ?? 'Detalhes do Procedimento'),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop(); // Fechar o diálogo
                  },
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Alinha o conteúdo à esquerda
                children: [
                  const SizedBox(height: 20),
                  DetailRow(label: 'Nome', value: procedure.name),
                  DetailRow(label: 'Descrição', value: procedure.description),
                  DetailRow(label: 'Dosagem', value: procedure.dosage),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  await _showDeleteDialog(context, procedure.id!.toString(),
                      'procedures', 'procedimento', onProcedureUpdated);
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Deletar'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _showEditProcedureDialog(
                      context, procedure, onProcedureUpdated);
                  
                },
                child: const Text('Editar'),
              ),
            ],
          );
        },
      );
    },
  );
}

Future<void> _showDeleteDialog(
  BuildContext context,
  String itemId,
  String route,
  String entityType,
  Function() onDeleted,
) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return DeleteConfirmationDialog(
        itemId: itemId,
        route: route,
        entityType: entityType,
        onDeleted: onDeleted,
      );
    },
  );
}

Future<void> _showEditProcedureDialog(BuildContext context, Procedure procedure,
    Function() onProcedureUpdated) async {
  final TextEditingController nameController =
      TextEditingController(text: procedure.name ?? '');
  final TextEditingController descriptionController =
      TextEditingController(text: procedure.description ?? '');
  final TextEditingController dosageController =
      TextEditingController(text: procedure.dosage ?? '');

  final loginProvider = Provider.of<LoginController>(context, listen: false);
  final customDio = CustomDio(loginProvider, context);
  final procedureRepository = ProcedureRepository(customDio);

  await showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Editar Procedimento'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(labelText: 'Nome'),
                    controller: nameController,
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Descrição'),
                    controller: descriptionController,
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Dosagem'),
                    controller: dosageController,
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
                    final updatedProcedure = Procedure(
                      id: procedure.id,
                      name: nameController.text,
                      description: descriptionController.text,
                      dosage: dosageController.text,
                    );

                    await procedureRepository.updateProcedure(updatedProcedure);
                    TopSnackBar.show(
                      context,
                      'Procedimento atualizado com sucesso',
                      true,
                    );
                    Navigator.of(context).pop(); // Fechar o diálogo de edição
                    Navigator.of(context).pop();
                    onProcedureUpdated(); // Atualizar a tela principal
                  } catch (e) {
                    if (e is DioException && e.response!.statusCode != 498) {
                      log(e.toString());
                      TopSnackBar.show(
                          context, 'Erro ao atualizar procedimento', false);
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
