import 'package:doce_lar/model/repositories/generic_delete_repository.dart';
import 'package:doce_lar/view/widgets/feedback_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doce_lar/controller/login_controller.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final String itemId;
  final String route;
  final String entityType;
  final Function() onDeleted;

  const DeleteConfirmationDialog({
    super.key,
    required this.itemId,
    required this.route,
    required this.entityType,
    required this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirmar Exclusão'),
      content: Text('Tem certeza que deseja excluir este $entityType?'),
      actions: [
        TextButton(
          child: const Text('Cancelar'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () async {
            final loginProvider =
                Provider.of<LoginController>(context, listen: false);
            final deleteRepository = DeleteRepository();

            try {
              await deleteRepository.deleteItem(
                endpoint: route,
                itemId: itemId,
                token: loginProvider.token,
              );
              Navigator.of(context).pop();
              TopSnackBar.show(
                  context, '$entityType excluído com sucesso!', true);
              onDeleted();
            } catch (e) {
              TopSnackBar.show(context, 'Falha ao excluir $entityType', false);
            }
          },
          child: const Text('Deletar'),
        ),
      ],
    );
  }
}
