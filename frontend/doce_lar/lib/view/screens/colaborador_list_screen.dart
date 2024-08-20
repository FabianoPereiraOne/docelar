import 'package:doce_lar/controller/login_controller.dart';
import 'package:doce_lar/model/repositories/colaborador_repository.dart';
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

  @override
  void initState() {
    super.initState();
    _fetchColaboradores();
  }

  void _fetchColaboradores() async {
    final loginProvider = Provider.of<LoginController>(context, listen: false);
    final colaboradorRepository = ColaboradoRepository();

    try {
      final colaboradores = await colaboradorRepository.fetchColaboradores(loginProvider.token);
      setState(() {
        _colaboradores = colaboradores;
        _filteredColaboradores = colaboradores;
      });
    } catch (e) {
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
            child: _filteredColaboradores.isEmpty
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
                          onTap: () {},
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
