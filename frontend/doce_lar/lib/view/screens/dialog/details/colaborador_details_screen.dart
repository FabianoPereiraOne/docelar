import 'package:doce_lar/controller/login_controller.dart';
import 'package:doce_lar/model/models/homes_model.dart';
import 'package:doce_lar/model/models/user_model.dart';
import 'package:doce_lar/model/repositories/colaborador_repository.dart';
import 'package:doce_lar/model/repositories/homes_repository.dart';
import 'package:doce_lar/view/screens/dialog/details/home_details_screen.dart';
import 'package:doce_lar/view/screens/dialog/add/endereco_dialog.dart';
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
                      // Aba "Detalhes"
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
                            SizedBox(height: 50),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Fechar o diálogo
                                    _showEditColaboradorDialog(context,
                                        colaborador, onColaboradorUpdated);
                                  },
                                  child: Text('Editar'),
                                ),
                                // ElevatedButton(
                                //   onPressed: () {
                                //     Navigator.of(context).pop(); // Fechar o diálogo
                                //     _confirmDeleteColaborador(context, colaborador.id!,
                                //         onColaboradorUpdated);
                                //   },
                                //   child: Text('Desativar'),
                                //   style: TextButton.styleFrom(
                                //       foregroundColor: Colors.red),
                                // ),
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
                                        trailing: Icon(Icons.search,
                                            color: Colors.grey),
                                        onTap: () {
                                          showHomeDetailDialog(
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
                              : Center(child: Text('Nenhum lar encontrado')),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Fechar o diálogo
                                showEnderecoDialog(context, colaborador.id!,
                                    onColaboradorUpdated);
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
              // Botão Fechar fora dos Tabs
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Fechar o diálogo
                    },
                    child: Text('Fechar'),
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





void _showEditColaboradorDialog(BuildContext context, Usuario colaborador,
    Function() onColaboradorUpdated) {

  final TextEditingController nameController =
      TextEditingController(text: colaborador.name ?? '');
  
  // Usando MaskedTextController para o campo de telefone
  final phoneController = MaskedTextController(mask: '(00) 00000-0000');
  phoneController.text = colaborador.phone ?? '';

  bool isActive = colaborador.statusAccount ?? true;
  String selectedRole = colaborador.type ?? 'USER'; // Cargo atual do usuário

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
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(15),
                    ],
                  ),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Cargo'),
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
                  final homeRepository = HomeRepository();

                  try {
                    // Atualizando o colaborador
                    final updatedColaborador = Usuario(
                      id: colaborador.id,
                      name: nameController.text,
                      phone: phoneController.text,
                      type: selectedRole, // Cargo selecionado
                      statusAccount: isActive,
                    );

                    await colaboradorRepository.updateColaborador(
                        updatedColaborador, loginProvider.token);

                    // Se o colaborador foi desativado, desativar também os lares associados
                    if (!isActive) {
                      print(
                          'Colaborador desativado, iniciando desativação dos lares...');

                      final homes = colaborador.homes;

                      if (homes!.isNotEmpty) {
                        for (var homeData in homes) {
                          // Convertendo o mapa para uma instância da classe Home
                          Home home = Home.fromMap(homeData);
                          home.status = false; // Desativando lar

                          try {
                            await homeRepository.updateHome(
                                home, loginProvider.token);
                            print('Lar ${home.id} desativado com sucesso.');
                          } catch (e) {
                            print('Erro ao desativar o lar ${home.id}: $e');
                          }
                        }
                      } else {
                        print('Nenhum lar associado ao colaborador.');
                      }
                    }

                    Navigator.of(context).pop(); // Fechar o diálogo de edição
                    onColaboradorUpdated(); // Atualizar a tela principal
                  } catch (e) {
                    print('Erro ao editar colaborador e lares: $e');
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
      title: Text('Confirmar Desativação'),
      content: Text('Tem certeza que deseja desativar este colaborador?'),
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
