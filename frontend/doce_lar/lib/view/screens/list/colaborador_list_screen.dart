import 'package:doce_lar/controller/interceptor_dio.dart';
import 'package:doce_lar/controller/login_controller.dart';
import 'package:doce_lar/model/repositories/colaborador_repository.dart';
import 'package:doce_lar/view/screens/dialog/add/colaborador_dialog.dart';
import 'package:doce_lar/view/screens/dialog/details/colaborador_details_screen.dart';
import 'package:doce_lar/view/widgets/custom_card.dart';
import 'package:flutter/material.dart';
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
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchColaboradores();
  }

  void _fetchColaboradores() async {
    final loginProvider = Provider.of<LoginController>(context, listen: false);
    final customDio = CustomDio(loginProvider, context);
    final colaboradorRepository = ColaboradorRepository(customDio);

    setState(() {
      _isLoading = true;
    });

    try {
      final colaboradores =
          await colaboradorRepository.fetchColaboradores();
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





  void _filterColaboradores(String query) {
    final filteredColaboradores = _colaboradores.where((colaborador) {
      final colaboradorLower = colaborador.name!.toLowerCase();
      final queryLower = query.toLowerCase();
      return colaboradorLower.contains(queryLower);
    }).toList();

    setState(() {
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
          onPressed: () async {
            await showColaboradorDialog(context, _fetchColaboradores);
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
