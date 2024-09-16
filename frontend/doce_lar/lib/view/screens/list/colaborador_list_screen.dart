import 'package:doce_lar/controller/login_controller.dart';
import 'package:doce_lar/model/repositories/colaborador_repository.dart';
import 'package:doce_lar/view/screens/dialog/details/colaborador_details_screen.dart';
import 'package:doce_lar/view/screens/dialog/endereco_dialog.dart';
import 'package:doce_lar/view/widgets/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:provider/provider.dart';
import 'package:doce_lar/model/models/user_model.dart';

class ColaboradorListScreen extends StatefulWidget {
  const ColaboradorListScreen({super.key});

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
        _activeColaboradores = colaboradores
            .where((colaborador) => colaborador.statusAccount!)
            .toList();
        _inactiveColaboradores = colaboradores
            .where((colaborador) => !colaborador.statusAccount!)
            .toList();
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
    if (input.isEmpty) {
      return '';
    }
    return input.split(' ').map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

void _showColaboradorDialog(BuildContext context) {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController =
      MaskedTextController(mask: '(00) 00000-0000');
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController(); // Controlador para confirmar senha
  String selectedUserType = 'USER';

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Adicionar Colaborador'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                  ],
                  controller: nameController,
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
                const SizedBox(height: 10),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
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
                const SizedBox(height: 10),
                TextFormField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: 'Telefone',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo obrigatório';
                    }
                    if (value.length < 15) {
                      return 'Número de telefone inválido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: passwordController,
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
                const SizedBox(height: 10),
                TextFormField(
                  controller: confirmPasswordController,
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
                    if (value != passwordController.text) {
                      return 'As senhas não coincidem';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedUserType,
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
                    selectedUserType = newValue ?? 'USER';
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
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              String formattedName = capitalizeWords(nameController.text);

              if (formKey.currentState?.validate() ?? false) {
                Usuario newColaborador = Usuario(
                  name: formattedName,
                  email: emailController.text,
                  phone: phoneController.text,
                  type: selectedUserType,
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
                    passwordController.text,
                  );
                  _fetchColaboradores();
                  Navigator.of(context).pop();
                  _showFeedbackDialog(context, 'Colaborador adicionado com sucesso!', true);
                  showEnderecoDialog(
                      context, colaboradorId, _fetchColaboradores);
                } catch (e) {
                  _showFeedbackDialog(context, 'Erro ao adicionar colaborador: $e', false);
                }
              }
            },
            child: const Text('Próximo'),
          ),
        ],
      );
    },
  );
}

  void _showFeedbackDialog(BuildContext context, String message, bool isSuccess) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(isSuccess ? 'Sucesso' : 'Erro'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Fechar'),
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
      _activeColaboradores = filteredColaboradores
          .where((colaborador) => colaborador.statusAccount!)
          .toList();
      _inactiveColaboradores = filteredColaboradores
          .where((colaborador) => !colaborador.statusAccount!)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Colaboradores'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/home');
            },
          ),
          bottom: const TabBar(
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
          backgroundColor: Colors.green,
          onPressed: () {
            _showColaboradorDialog(context);
          },
          child: const Icon(Icons.add),
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
              prefixIcon: const Icon(Icons.search, color: Colors.green),
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
              ? const Center(child: CircularProgressIndicator())
              : colaboradores.isEmpty
                  ? const Center(child: Text('Nenhum colaborador encontrado'))
                  : ListView.builder(
                      itemCount: colaboradores.length,
                      itemBuilder: (context, index) {
                        final colaborador = colaboradores[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomCard(
                            title: colaborador.name.toString(),
                            info1: colaborador.email.toString(),
                            info2: colaborador.phone.toString(),
                            onTap: () {
                              showColaboradorDetailDialog(
                                  context, colaborador, _fetchColaboradores);
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
