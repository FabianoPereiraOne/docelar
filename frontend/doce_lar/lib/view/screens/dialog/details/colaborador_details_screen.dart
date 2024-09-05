import 'dart:developer';

import 'package:doce_lar/controller/login_controller.dart';
import 'package:doce_lar/model/models/homes_model.dart';
import 'package:doce_lar/model/models/user_model.dart';
import 'package:doce_lar/model/repositories/colaborador_repository.dart';
import 'package:doce_lar/model/repositories/homes_repository.dart';
import 'package:doce_lar/view/screens/dialog/details/home_details_screen.dart';
import 'package:doce_lar/view/screens/dialog/endereco_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void showColaboradorDetailDialog(BuildContext context, Usuario colaborador,
    Function() onColaboradorUpdated) {
  final loginProvider = Provider.of<LoginController>(context, listen: false);
  final homeRepository = HomeRepository(); // Instanciar o HomeRepository

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
                child: TabBar(
                  tabs: [
                    Tab(text: 'Detalhes'),
                    Tab(text: 'Lares'),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 300, // Ajuste a altura conforme necessário
                  child: TabBarView(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20),
                            _buildDetailRow('Nome', colaborador.name),
                            _buildDetailRow('Email', colaborador.email),
                            _buildDetailRow('Telefone', colaborador.phone),
                            _buildDetailRow('Cargo', colaborador.type),
                            _buildDetailRow(
                                'Status',
                                colaborador.statusAccount == true
                                    ? 'Ativo'
                                    : 'Inativo'),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Expanded(
                            child: FutureBuilder<List<Home>>(
                              future: _fetchAndFilterHomes(homeRepository,
                                  loginProvider.token, colaborador.id!),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Center(
                                      child: Text('Erro ao carregar lares'));
                                } else if (!snapshot.hasData ||
                                    snapshot.data!.isEmpty) {
                                  return Center(
                                      child: Text('Nenhum lar encontrado'));
                                }

                                final homes = snapshot.data!;

                                return ListView.builder(
                                  itemCount: homes.length,
                                  itemBuilder: (context, index) {
                                    final home = homes[index];
                                    return ListTile(
                                      title: Text(home.address!),
                                      subtitle: Text(
                                          '${home.district}, ${home.number}'),
                                      trailing: Icon(Icons.search,
                                          color: Colors.grey),
                                      onTap: () {
                                        showHomeDetailDialog(
                                          context,
                                          home,
                                          () {
                                            Navigator.of(context)
                                                .pop(); // Fechar o diálogo de detalhes
                                            onColaboradorUpdated(); // Atualizar a tela principal
                                          },
                                        );
                                      },
                                      tileColor: home.status!
                                          ? Colors.green[100]
                                          : Colors.yellow[
                                              100], // Define a cor de fundo com base no status
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Fechar o diálogo
                                showEnderecoDialog(context, colaborador.id!);
                              },
                              child: Text('Adicionar Novo Lar'),
                            ),
                          ),
                        ],
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
                      Navigator.of(context).pop(); // Fechar o diálogo
                      _showEditColaboradorDialog(
                          context, colaborador, onColaboradorUpdated);
                    },
                    child: Text('Editar'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Fechar o diálogo
                      _confirmDeleteColaborador(
                          context, colaborador.id!, onColaboradorUpdated);
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

Future<List<Home>> _fetchAndFilterHomes(
    HomeRepository homeRepository, String token, String collaboratorId) async {
  try {
    final allHomes = await homeRepository.fetchHomes(token);
    return allHomes
        .where((home) => home.collaboratorId == collaboratorId)
        .toList();
  } catch (e) {
    throw Exception('Erro ao buscar lares: $e');
  }
}

void _showEditColaboradorDialog(BuildContext context, Usuario colaborador,
    Function() onColaboradorUpdated) {
  final TextEditingController nameController =
      TextEditingController(text: colaborador.name ?? '');
  final TextEditingController emailController =
      TextEditingController(text: colaborador.email ?? '');
  final TextEditingController phoneController =
      TextEditingController(text: colaborador.phone ?? '');
  final TextEditingController roleController =
      TextEditingController(text: colaborador.type ?? '');

  bool isActive = colaborador.statusAccount ?? true;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Editar Colaborador'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: InputDecoration(labelText: 'Nome'),
                    controller: nameController,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Telefone'),
                    controller: phoneController,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Cargo'),
                    controller: roleController,
                  ),
                  SwitchListTile(
                    title: Text('Status'),
                    value: isActive,
                    onChanged: (value) {
                      setState(() {
                        isActive = value;
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
                  final loginProvider =
                      Provider.of<LoginController>(context, listen: false);
                  final colaboradorRepository = ColaboradorRepository();

                  try {
                    final updatedColaborador = Usuario(
                      id: colaborador.id,
                      name: nameController.text,
                      email: emailController.text,
                      phone: phoneController.text,
                      type: roleController.text,
                      statusAccount: isActive,
                    );

                    await colaboradorRepository.updateColaborador(
                        updatedColaborador, loginProvider.token);

                    Navigator.of(context).pop(); // Fechar o diálogo de edição
                    onColaboradorUpdated(); // Atualizar a tela principal
                  } catch (e) {
                    print('Erro ao editar colaborador: $e');
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

void _confirmDeleteColaborador(BuildContext context, String colaboradorId,
    Function() onColaboradorDeleted) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Confirmar Exclusão'),
      content: Text('Tem certeza que deseja excluir este colaborador?'),
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
            final loginProvider =
                Provider.of<LoginController>(context, listen: false);
            final colaboradorRepository = ColaboradorRepository();

            try {
              await colaboradorRepository.deleteColaborador(
                  colaboradorId, loginProvider.token);
              Navigator.of(context).pop(); // Fechar o diálogo de confirmação
              onColaboradorDeleted(); // Atualizar a tela principal
            } catch (e) {
              print('Erro ao excluir colaborador: $e');
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
