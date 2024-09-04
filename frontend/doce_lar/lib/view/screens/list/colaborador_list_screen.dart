import 'dart:developer';

import 'package:doce_lar/controller/login_controller.dart';
import 'package:doce_lar/model/models/homes_model.dart';
import 'package:doce_lar/model/repositories/colaborador_repository.dart';
import 'package:doce_lar/model/repositories/homes_repository.dart';
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
      final colaboradores = await colaboradorRepository.fetchColaboradores(loginProvider.token);
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
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController(); // Novo campo para a senha
  String _selectedUserType = 'USER';

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Adicionar Colaborador'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nome'),
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Telefone'),
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Senha'), // Campo para a senha
                obscureText: true,
              ),
              DropdownButtonFormField<String>(
                value: _selectedUserType,
                decoration: InputDecoration(labelText: 'Tipo de Usuário'),
                items: <String>['USER', 'ADMIN'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedUserType = newValue ?? 'USER';
                  });
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (_nameController.text.isEmpty ||
                  _emailController.text.isEmpty ||
                  _phoneController.text.isEmpty ||
                  _passwordController.text.isEmpty) { // Validação para a senha
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Todos os campos são obrigatórios.')),
                );
                return;
              }

              Usuario newColaborador = Usuario(
                name: _nameController.text,
                email: _emailController.text,
                phone: _phoneController.text,
                type: _selectedUserType,
                statusAccount: true,
              );

              final loginProvider = Provider.of<LoginController>(context, listen: false);
              final colaboradorRepository = ColaboradoRepository();

              try {
                // Captura o ID do colaborador recém-criado
                final String colaboradorId = await colaboradorRepository.addPartner(
                  newColaborador,
                  loginProvider.token,
                  _passwordController.text, // Passa a senha aqui
                );
                _fetchColaboradores(); // Atualiza a lista de colaboradores
                Navigator.of(context).pop();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Colaborador adicionado com sucesso!')),
                );

                _showEnderecoDialog(context, colaboradorId);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Erro ao adicionar colaborador: $e')),
                );
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
                decoration: InputDecoration(labelText: 'CEP'),
              ),
              TextField(
                controller: _ruaController,
                decoration: InputDecoration(labelText: 'Rua'),
              ),
              TextField(
                controller: _cidadeController,
                decoration: InputDecoration(labelText: 'Cidade'),
              ),
              TextField(
                controller: _estadoController,
                decoration: InputDecoration(labelText: 'Estado'),
              ),
              TextField(
                controller: _districtController,
                decoration: InputDecoration(labelText: 'Bairro'),
              ),
              TextField(
                controller: _numeroController,
                decoration: InputDecoration(labelText: 'Número'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              final cep = _cepController.text.trim();
              final rua = _ruaController.text.trim();
              final cidade = _cidadeController.text.trim();
              final estado = _estadoController.text.trim();
              final district = _districtController.text.trim();
              final numero = _numeroController.text.trim();

              if (cep.isNotEmpty && rua.isNotEmpty && cidade.isNotEmpty && estado.isNotEmpty && district.isNotEmpty && numero.isNotEmpty) {
                final newHome = Home(
                  cep: cep,
                  state: estado,
                  city: cidade,
                  district: district,
                  address: rua,
                  number: numero,
                  status: true, // Ou defina conforme a lógica
                  collaboratorId: colaboradorId,
                );

                // Chame o método addHome para adicionar o endereço
                final homeRepository = HomeRepository();
                homeRepository.addHome(newHome, loginProvider.token).then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Endereço adicionado para o colaborador $colaboradorId!')),
                  );
                  Navigator.of(context).pop(); // Fechar o diálogo
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao adicionar endereço: $error')),
                  );
                });
              } else {
                // Se o formulário estiver vazio, apenas fechar o diálogo
                Navigator.of(context).pop();
              }
            },
            child: Text('Concluir'),
          ),
          TextButton(
            onPressed: () {
              final cep = _cepController.text.trim();
              final rua = _ruaController.text.trim();
              final cidade = _cidadeController.text.trim();
              final estado = _estadoController.text.trim();
              final district = _districtController.text.trim();
              final numero = _numeroController.text.trim();

              if (cep.isNotEmpty && rua.isNotEmpty && cidade.isNotEmpty && estado.isNotEmpty && district.isNotEmpty && numero.isNotEmpty) {
                final newHome = Home(
                  cep: cep,
                  state: estado,
                  city: cidade,
                  district: district,
                  address: rua,
                  number: numero,
                  status: true, // Ou defina conforme a lógica
                  collaboratorId: colaboradorId,
                );

                // Chame o método addHome para adicionar o endereço
                final homeRepository = HomeRepository();
                homeRepository.addHome(newHome, loginProvider.token).then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Endereço adicionado para o colaborador $colaboradorId!')),
                  );
                Navigator.of(context).pop(); // Fechar o diálogo
                Future.delayed(Duration(milliseconds: 300), () {
                      _showEnderecoDialog(context, colaboradorId); // Reabrir o diálogo
                    });
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao adicionar endereço: $error')),
                  );
                });
                
                _showEnderecoDialog(context, colaboradorId);
              } else {
                // Se o formulário estiver vazio, apenas fechar o diálogo
                Navigator.of(context).pop();
              }
              
            },
            child: Text('Novo endereço'),
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
                ? Center(child: CircularProgressIndicator()) // Exibe o indicador de progresso enquanto carrega
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
