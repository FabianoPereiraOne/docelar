import 'package:doce_lar/controller/login_controller.dart';
import 'package:doce_lar/model/models/procedure_model.dart';
import 'package:doce_lar/model/repositories/procedure_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void showProcedureDetailDialog(BuildContext context, Procedure procedure, Function() onProcedureUpdated) async {
  showDialog(
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
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop(); // Fechar o diálogo
                  },
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start, // Alinha o conteúdo à esquerda
                children: [
                  SizedBox(height: 20),
                  _buildDetailRow('Nome', procedure.name),
                  _buildDetailRow('Descrição', procedure.description),
                  _buildDetailRow('Dosagem', procedure.dosage),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Fechar o diálogo
                  _showEditProcedureDialog(context, procedure, onProcedureUpdated);
                },
                child: Text('Editar'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Fechar o diálogo
                  _confirmDeleteProcedure(context, procedure.id!, onProcedureUpdated);
                },
                child: Text('Deletar'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
            ],
          );
        },
      );
    },
  );
}

void _confirmDeleteProcedure(BuildContext context, int procedureId, Function() onProcedureDeleted) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Confirmar Exclusão'),
      content: Text('Tem certeza que deseja excluir este procedimento?'),
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
            final procedureRepository = ProcedureRepository();

            try {
              await procedureRepository.deleteProcedure(procedureId, loginProvider.token);
              Navigator.of(context).pop(); // Fechar o diálogo de confirmação
              onProcedureDeleted(); // Atualizar a tela principal
            } catch (e) {
              print('Erro ao excluir procedimento: $e');
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

void _showEditProcedureDialog(BuildContext context, Procedure procedure, Function() onProcedureUpdated) {
  final TextEditingController nameController = TextEditingController(text: procedure.name ?? '');
  final TextEditingController descriptionController = TextEditingController(text: procedure.description ?? '');
  final TextEditingController dosageController = TextEditingController(text: procedure.dosage ?? '');

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Editar Procedimento'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: InputDecoration(labelText: 'Nome'),
                    controller: nameController,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Descrição'),
                    controller: descriptionController,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Dosagem'),
                    controller: dosageController,
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
                  final procedureRepository = ProcedureRepository();

                  try {
                    final updatedProcedure = Procedure(
                      id: procedure.id,
                      name: nameController.text,
                      description: descriptionController.text,
                      dosage: dosageController.text,
                    );

                    await procedureRepository.updateProcedure(updatedProcedure, loginProvider.token);

                    Navigator.of(context).pop(); // Fechar o diálogo de edição
                    onProcedureUpdated(); // Atualizar a tela principal
                  } catch (e) {
                    print('Erro ao editar procedimento: $e');
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
