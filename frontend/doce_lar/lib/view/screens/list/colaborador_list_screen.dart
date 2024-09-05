import 'dart:developer';

import 'package:doce_lar/controller/login_controller.dart';
import 'package:doce_lar/model/repositories/colaborador_repository.dart';
import 'package:doce_lar/utils/masks.dart';
import 'package:doce_lar/view/screens/dialog/details/colaborador_details_screen.dart';
import 'package:doce_lar/view/screens/dialog/endereco_dialog.dart';
import 'package:doce_lar/view/widgets/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:doce_lar/model/models/user_model.dart';

class ColaboradorListScreen extends StatefulWidget {
  @override
  _ColaboradorListScreenState createState() => _ColaboradorListScreenState();
}

class _ColaboradorListScreenState extends State<ColaboradorListScreen> {
  List<Usuario> _colaboradores = [];
  List<Usuario> _activeColaboradores = [];
  List<Usuario> _inactiveColaboradores = [];
  String _searchQuery = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchColaboradores();
  }

  void _fetchColaboradores() async {
    final loginProvider = Provider.of<LoginController>(context, listen: false);
    final colaboradorRepository = ColaboradorRepository();

    setState(() {
      _isLoading = true;
    });

    try {
      final colaboradores =
          await colaboradorRepository.fetchColaboradores(loginProvider.token);
      setState(() {
        _colaboradores = colaboradores;
        _activeColaboradores = colaboradores.where((colaborador) => colaborador.statusAccount!).toList();
        _inactiveColaboradores = colaboradores.where((colaborador) => !colaborador.statusAccount!).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Trate o erro adequadamente
    }
  }

  String capitalizeWords(String input) {
    if (input == null || input.isEmpty) {
      return '';
    }
    return input.split(' ').map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  void _showColaboradorDialog(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _phoneController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    final TextEditingController _confirmPasswordController =
        TextEditingController(); // Controlador para confirmar senha
    String _selectedUserType = 'USER';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Adicionar Colaborador'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                    ],
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Nome',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo obrigatório';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    inputFormatters: [InputMasks.emailMask],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo obrigatório';
                      }
                      if (!RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value)) {
                        return 'Email inválido';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: 'Telefone',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    inputFormatters: [InputMasks.phoneMask],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo obrigatório';
                      }
                      if (value.length < 15) {
                        // Telefone no formato (XX) XXXXX-XXXX tem 15 caracteres
                        return 'Número de telefone inválido';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo obrigatório';
                      }
                      if (value.length < 6) {
                        return 'A senha deve ter no mínimo 6 caracteres';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Confirmar Senha',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo obrigatório';
                      }
                      if (value != _passwordController.text) {
                        return 'As senhas não coincidem';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: _selectedUserType,
                    decoration: InputDecoration(
                      labelText: 'Tipo de Usuário',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    items: <String>['USER', 'ADMIN'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      _selectedUserType = newValue ?? 'USER';
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
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                String formattedName = capitalizeWords(_nameController.text);

                if (_formKey.currentState?.validate() ?? false) {
                  Usuario newColaborador = Usuario(
                    name: formattedName,
                    email: _emailController.text,
                    phone: _phoneController.text,
                    type: _selectedUserType,
                    statusAccount: true,
                  );

                  final loginProvider =
                      Provider.of<LoginController>(context, listen: false);
                  final colaboradorRepository = ColaboradorRepository();

                  try {
                    final String colaboradorId =
                        await colaboradorRepository.addPartner(
                      newColaborador,
                      loginProvider.token,
                      _passwordController.text,
                    );
                    _fetchColaboradores();
                    Navigator.of(context).pop();

                    showEnderecoDialog(context, colaboradorId);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Erro ao adicionar colaborador: $e')),
                    );
                  }
                }
              },
              child: Text('Próximo'),
            ),
          ],
        );
      },
    );
  }

  void _filterColaboradores(String query) {
    final filteredColaboradores = _colaboradores.where((colaborador) {
      final colaboradorLower = colaborador.name!.toLowerCase();
      final queryLower = query.toLowerCase();
      return colaboradorLower.contains(queryLower);
    }).toList();

    setState(() {
      _searchQuery = query;
      _activeColaboradores = filteredColaboradores.where((colaborador) => colaborador.statusAccount!).toList();
      _inactiveColaboradores = filteredColaboradores.where((colaborador) => !colaborador.statusAccount!).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Colaboradores'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/base');
            },
          ),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Ativos'),
              Tab(text: 'Inativos'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildColaboradorList(_activeColaboradores),
            _buildColaboradorList(_inactiveColaboradores),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showColaboradorDialog(context);
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildColaboradorList(List<Usuario> colaboradores) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Pesquisar colaborador...',
              prefixIcon: Icon(Icons.search, color: Colors.green),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            onChanged: _filterColaboradores,
          ),
        ),
        Expanded(
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : colaboradores.isEmpty
                  ? Center(child: Text('Nenhum colaborador encontrado'))
                  : ListView.builder(
                      itemCount: colaboradores.length,
                      itemBuilder: (context, index) {
                        final colaborador = colaboradores[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomCard(
                            name: colaborador.name.toString(),
                            email: colaborador.email.toString(),
                            phone: colaborador.phone.toString(),
                            onTap: () {
                              showColaboradorDetailDialog(
                                context,
                                colaborador,
                                () {
                                  _fetchColaboradores();
                                },
                              );
                            },
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }
}
