import 'dart:developer';

import 'package:doce_lar/controller/interceptor_dio.dart';
import 'package:doce_lar/controller/login_controller.dart';
import 'package:doce_lar/model/models/homes_model.dart';
import 'package:doce_lar/model/models/user_model.dart';
import 'package:doce_lar/model/repositories/colaborador_repository.dart';
import 'package:doce_lar/model/repositories/homes_repository.dart';
import 'package:doce_lar/view/screens/dialog/details/home_details_screen.dart';
import 'package:doce_lar/view/screens/dialog/add/endereco_dialog.dart';
import 'package:doce_lar/view/widgets/detail_row.dart';
import 'package:doce_lar/view/widgets/feedback_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:provider/provider.dart';

void showColaboradorDetailDialog(BuildContext context, Usuario colaborador,
    Function() onColaboradorUpdated) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        child: DefaultTabController(
          length: 2, // Número de abas
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                color: Colors.white,
                child: const TabBar(
                  tabs: [
                    Tab(text: 'Detalhes'),
                    Tab(text: 'Lares'),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 300, // Ajuste a altura conforme necessário
                  child: TabBarView(
                    children: [
                      // Aba "Detalhes"
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            Center(
                              child: Text(colaborador.name ?? 'N/A',
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold)),
                            ),
                            DetailRow(label: 'Email', value: colaborador.email),
                            DetailRow(
                                label: 'Telefone', value: colaborador.phone),
                            DetailRow(label: 'Cargo', value: colaborador.type),
                            DetailRow(
                                label: 'Status',
                                value: colaborador.statusAccount == true
                                    ? 'Ativo'
                                    : 'Inativo'),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    await _showEditColaboradorDialog(context,
                                        colaborador, onColaboradorUpdated);
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Editar'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Aba "Lares"
                      Column(
                        children: [
                          colaborador.homes != null &&
                                  colaborador.homes!.isNotEmpty
                              ? Expanded(
                                  child: ListView.builder(
                                    itemCount: colaborador.homes!.length,
                                    itemBuilder: (context, index) {
                                      final home = Home.fromMap(
                                          colaborador.homes![index]);
                                      return ListTile(
                                        title: Text(home.address!),
                                        subtitle: Text(
                                            '${home.district}, ${home.number}'),
                                        trailing: const Icon(Icons.search,
                                            color: Colors.grey),
                                        onTap: () async {
                                          await showHomeDetailDialog(
                                            context,
                                            home,
                                            () {
                                              Navigator.of(context).pop();
                                              onColaboradorUpdated();
                                            },
                                          );
                                        },
                                        tileColor: home.status!
                                            ? Colors.green[100]
                                            : Colors.yellow[100],
                                      );
                                    },
                                  ),
                                )
                              : const Center(
                                  child: Text('Nenhum lar encontrado')),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () async {
                                await showEnderecoDialog(context, colaborador.id!,
                                    onColaboradorUpdated);
                                Navigator.of(context).pop();
                              },
                              child: const Text('Adicionar Novo Lar'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Botão Fechar fora dos Tabs
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Fechar o diálogo
                    },
                    child: const Text('Fechar'),
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

Future<void> _showEditColaboradorDialog(BuildContext context,
    Usuario colaborador, Function() onColaboradorUpdated) async {
  final TextEditingController nameController =
      TextEditingController(text: colaborador.name ?? '');

  final phoneController = MaskedTextController(mask: '(00) 00000-0000');
  phoneController.text = colaborador.phone ?? '';

  bool isActive = colaborador.statusAccount ?? true;
  String selectedRole = colaborador.type ?? 'USER'; // Cargo atual do usuário

  // Controladores para senha
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final loginProvider = Provider.of<LoginController>(context, listen: false);
  final customDio = CustomDio(loginProvider, context);
  final colaboradorRepository = ColaboradorRepository(customDio);
  final homeRepository = HomeRepository(customDio);
  bool initialStatus = isActive; // Armazena o status inicial

  await showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Editar Colaborador'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(labelText: 'Nome'),
                    controller: nameController,
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Telefone'),
                    controller: phoneController,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(15),
                    ],
                  ),
                  TextField(
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Nova Senha'),
                    controller: passwordController,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    obscureText: true,
                    decoration:
                        const InputDecoration(labelText: 'Confirmar Senha'),
                    controller: confirmPasswordController,
                  ),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Cargo'),
                    value: selectedRole,
                    items: ['USER', 'ADMIN'].map((String role) {
                      return DropdownMenuItem<String>(
                        value: role,
                        child: Text(role),
                      );
                    }).toList(),
                    onChanged: (String? newRole) {
                      setState(() {
                        selectedRole = newRole!;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Status'),
                    value: isActive,
                    onChanged: (value) {
                      setState(() {
                        isActive = value;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
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
                    // Validar e atualizar a senha se fornecida
                    String? newPassword;
                    if (passwordController.text.isNotEmpty) {
                      if (passwordController.text ==
                          confirmPasswordController.text) {
                        newPassword = passwordController.text;
                      } else {
                        TopSnackBar.show(
                          context,
                          'As senhas não coincidem',
                          false,
                        );
                        return;
                      }
                    }

                    // Atualizando o colaborador
                    final updatedColaborador = Usuario(
                      id: colaborador.id,
                      name: nameController.text,
                      phone: phoneController.text,
                      type: selectedRole, // Cargo selecionado
                      statusAccount: isActive,
                    );

                    await colaboradorRepository.updateColaborador(
                        updatedColaborador, newPassword);

                    bool statusChanged = initialStatus != isActive;

                    if (!isActive) {
                      log('Colaborador desativado, iniciando desativação dos lares...');

                      final homes = colaborador.homes;

                      if (homes!.isNotEmpty) {
                        for (var homeData in homes) {
                          Home home = Home.fromMap(homeData);
                          home.status = false;

                          try {
                            await homeRepository.updateHome(home);
                            log('Lar ${home.id} desativado com sucesso.');
                          } catch (e) {
                            log('Erro ao desativar o lar ${home.id}: $e');
                          }
                        }
                      } else {
                        log('Nenhum lar associado ao colaborador.');
                      }

                      if (statusChanged) {
                        TopSnackBar.show(
                          context,
                          'Colaborador desativado',
                          false,
                        );
                      }
                    } else {
                      if (statusChanged) {
                        TopSnackBar.show(
                          context,
                          'Colaborador ativado',
                          true,
                        );
                      }
                    }

                    if (!statusChanged) {
                      TopSnackBar.show(
                        context,
                        'Colaborador atualizado com sucesso',
                        true,
                      );
                    }

                    Navigator.of(context).pop(); // Fechar o diálogo de edição
                    onColaboradorUpdated(); // Atualizar a tela principal
                  } catch (e) {
                    log('Erro ao editar colaborador e lares: $e');
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
