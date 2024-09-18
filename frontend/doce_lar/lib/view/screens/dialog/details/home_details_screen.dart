import 'dart:developer';

import 'package:doce_lar/controller/cep.dart';
import 'package:doce_lar/controller/login_controller.dart';
import 'package:doce_lar/model/models/homes_model.dart';
import 'package:doce_lar/model/repositories/homes_repository.dart';
import 'package:doce_lar/view/widgets/confirm_delete.dart';
import 'package:doce_lar/view/widgets/detail_row.dart';
import 'package:doce_lar/view/widgets/feedback_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:provider/provider.dart';

void showHomeDetailDialog(
    BuildContext context, Home home, Function() onHomeUpdated) async {
  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop(); // Fechar o diálogo
                      },
                    ),
                  ],
                ),
                Text(
                  home.address ?? 'Endereço não disponível',
                  maxLines: null, // Permite múltiplas linhas
                  overflow: TextOverflow
                      .visible, // Exibe o texto além da largura disponível
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  DetailRow(label: 'CEP', value: home.cep),
                  DetailRow(label: 'Estado', value: home.state),
                  DetailRow(label: 'Cidade', value: home.city),
                  DetailRow(label: 'Bairro', value: home.district),
                  DetailRow(label: 'Endereço', value: home.address),
                  DetailRow(label: 'Número', value: home.number),
                  DetailRow(
                      label: 'Status',
                      value: home.status == true ? 'Ativo' : 'Inativo'),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  showDeleteDialog(
                    context,
                    home.id!,
                    'homes',
                    'lar',
                    onHomeUpdated,
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Deletar'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Fechar o diálogo
                  _showEditHomeDialog(context, home, onHomeUpdated);
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

void showDeleteDialog(
  BuildContext context,
  String itemId,
  String route,
  String entityType,
  Function() onDeleted,
) {
  showDialog(
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

void _showEditHomeDialog(
    BuildContext context, Home home, Function() onHomeUpdated) {
  final TextEditingController cepController =
      MaskedTextController(mask: '00000-000', text: home.cep ?? '');
  final TextEditingController stateController =
      TextEditingController(text: home.state ?? '');
  final TextEditingController cityController =
      TextEditingController(text: home.city ?? '');
  final TextEditingController districtController =
      TextEditingController(text: home.district ?? '');
  final TextEditingController addressController =
      TextEditingController(text: home.address ?? '');
  final TextEditingController numberController =
      TextEditingController(text: home.number ?? '');

  bool initialStatus = home.status ?? true;
  bool status = initialStatus;

  // Adicione o listener para buscar o CEP automaticamente
  cepController.addListener(() async {
    String cep = cepController.text.replaceAll('-', '');
    if (cep.length == 8) {
      await _buscarCep(cep, stateController, cityController, districtController,
          addressController);
    }
  });

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Editar Lar'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                  final loginProvider =
                      Provider.of<LoginController>(context, listen: false);
                  final homeRepository = HomeRepository();

                  try {
                    final updatedHome = Home(
                      id: home.id,
                      cep: cepController.text,
                      state: stateController.text,
                      city: cityController.text,
                      district: districtController.text,
                      address: addressController.text,
                      number: numberController.text,
                      status: status,
                    );

                    await homeRepository.updateHome(
                        updatedHome, loginProvider.token);

                    // Exibindo mensagem com base na alteração do status
                    if (initialStatus != status) {
                      if (!status) {
                        TopSnackBar.show(
                          context,
                          'Lar desativado',
                          false,
                        );
                      } else {
                        TopSnackBar.show(
                          context,
                          'Lar ativado',
                          true,
                        );
                      }
                    } else {
                      TopSnackBar.show(
                        context,
                        'Lar atualizado com sucesso',
                        true,
                      );
                    }

                    Navigator.of(context).pop(); // Fechar o diálogo de edição
                    onHomeUpdated(); // Atualizar a tela principal
                  } catch (e) {
                    log('Erro ao editar Lar: $e');
                    TopSnackBar.show(
                      context,
                      'Erro ao atualizar Lar',
                      false,
                    );
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

Future<void> _buscarCep(
    String cep,
    TextEditingController stateController,
    TextEditingController cityController,
    TextEditingController districtController,
    TextEditingController addressController) async {
  try {
    String cepSemHifen = cep.replaceAll('-', '');

    if (cepSemHifen.length == 8) {
      final endereco = await CepService().buscarEnderecoPorCep(cepSemHifen);
      if (endereco != null) {
        addressController.text = endereco['logradouro'] ?? '';
        cityController.text = endereco['localidade'] ?? '';
        stateController.text = endereco['uf'] ?? '';
        districtController.text = endereco['bairro'] ?? '';
      } else {}
    }
  } catch (e) {
    print('Erro ao buscar CEP: $e');
  }
}
