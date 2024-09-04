import 'dart:developer';

import 'package:doce_lar/controller/login_controller.dart';
import 'package:doce_lar/model/models/homes_model.dart';
import 'package:doce_lar/model/repositories/colaborador_repository.dart';
import 'package:doce_lar/model/repositories/homes_repository.dart';
import 'package:doce_lar/utils/masks.dart';
import 'package:doce_lar/view/widgets/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doce_lar/model/models/user_model.dart';

class ColaboradorListScreen extends StatefulWidget {
  @override
  _ColaboradorListScreenState createState() => _ColaboradorListScreenState();
}

class _ColaboradorListScreenState extends State<ColaboradorListScreen> {
  List<Usuario> _colaboradores = [];
  List<Usuario> _filteredColaboradores = [];
  String _searchQuery = '';
  bool _isLoading = false; // Variável para rastrear o estado de carregamento

  @override
  void initState() {
    super.initState();
    _fetchColaboradores();
  }

  void _fetchColaboradores() async {
    final loginProvider = Provider.of<LoginController>(context, listen: false);
    final colaboradorRepository = ColaboradoRepository();

    setState(() {
      _isLoading = true; // Inicia o carregamento
    });

    try {
      final colaboradores =
          await colaboradorRepository.fetchColaboradores(loginProvider.token);
      setState(() {
        _colaboradores = colaboradores;
        _filteredColaboradores = colaboradores;
        _isLoading = false; // Finaliza o carregamento
      });
    } catch (e) {
      setState(() {
        _isLoading = false; // Finaliza o carregamento em caso de erro
      });
      // Trate o erro adequadamente
    }
  }

  void _showColaboradorDialog(BuildContext context) {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController(); // Controlador para confirmar senha
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
                    if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
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
                    if (value.length < 15) { // Telefone no formato (XX) XXXXX-XXXX tem 15 caracteres
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
              if (_formKey.currentState?.validate() ?? false) {
                Usuario newColaborador = Usuario(
                  name: _nameController.text,
                  email: _emailController.text,
                  phone: _phoneController.text,
                  type: _selectedUserType,
                  statusAccount: true,
                );

                final loginProvider =
                    Provider.of<LoginController>(context, listen: false);
                final colaboradorRepository = ColaboradoRepository();

                try {
                  final String colaboradorId =
                      await colaboradorRepository.addPartner(
                    newColaborador,
                    loginProvider.token,
                    _passwordController.text,
                  );
                  _fetchColaboradores();
                  Navigator.of(context).pop();

                  _showEnderecoDialog(context, colaboradorId);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao adicionar colaborador: $e')),
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

  void _showEnderecoDialog(BuildContext context, String colaboradorId) {
    final TextEditingController _ruaController = TextEditingController();
    final TextEditingController _cidadeController = TextEditingController();
    final TextEditingController _estadoController = TextEditingController();
    final TextEditingController _cepController = TextEditingController();
    final TextEditingController _districtController = TextEditingController();
    final TextEditingController _numeroController = TextEditingController();
    final loginProvider = Provider.of<LoginController>(context, listen: false);
    log('Colaborador ID: $colaboradorId');

    Future<void> _addEndereco() async {
      final cep = _cepController.text;
      final rua = _ruaController.text;
      final cidade = _cidadeController.text;
      final estado = _estadoController.text;
      final district = _districtController.text;
      final numero = _numeroController.text;

      if (cep.isNotEmpty &&
          rua.isNotEmpty &&
          cidade.isNotEmpty &&
          estado.isNotEmpty &&
          district.isNotEmpty &&
          numero.isNotEmpty) {
        final newHome = Home(
          cep: cep,
          state: estado,
          city: cidade,
          district: district,
          address: rua,
          number: numero,
          status: true,
          collaboratorId: colaboradorId,
        );

        final homeRepository = HomeRepository();
        await homeRepository.addHome(newHome, loginProvider.token);
      } else {
        log('Campos vazios');
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Adicionar Endereço'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _cepController,
                  decoration: InputDecoration(
                    labelText: 'CEP',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _ruaController,
                  decoration: InputDecoration(
                    labelText: 'Rua',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _cidadeController,
                  decoration: InputDecoration(
                    labelText: 'Cidade',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _estadoController,
                  decoration: InputDecoration(
                    labelText: 'Estado',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _districtController,
                  decoration: InputDecoration(
                    labelText: 'Bairro',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _numeroController,
                  decoration: InputDecoration(
                    labelText: 'Número',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await _addEndereco();
                Navigator.of(context).pop();
                _showEnderecoDialog(context, colaboradorId);
              },
              child: Text('Novo endereço'),
            ),
            TextButton(
              onPressed: () async {
                await _addEndereco();
                // Limpar os campos após adicionar o endereço e fechar o diálogo
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Colaborador cadastrado com sucesso!')),
                );
              },
              child: Text('Concluir'),
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
      _filteredColaboradores = filteredColaboradores;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Colaboradores'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/base');
          },
        ),
      ),
      body: Column(
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
                ? Center(
                    child:
                        CircularProgressIndicator()) // Exibe o indicador de progresso enquanto carrega
                : _filteredColaboradores.isEmpty
                    ? Center(child: Text('Nenhum colaborador encontrado'))
                    : ListView.builder(
                        itemCount: _filteredColaboradores.length,
                        itemBuilder: (context, index) {
                          final colaborador = _filteredColaboradores[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CustomCard(
                              name: colaborador.name.toString(),
                              email: colaborador.email.toString(),
                              phone: colaborador.phone.toString(),
                              onTap: () {
                                // Navegar para a tela de detalhes do colaborador
                              },
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showColaboradorDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
