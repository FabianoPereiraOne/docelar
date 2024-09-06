import 'package:doce_lar/controller/login_controller.dart';
import 'package:doce_lar/model/repositories/procedure_repository.dart';
import 'package:doce_lar/view/screens/dialog/details/procedure_details_screen.dart';
import 'package:doce_lar/view/widgets/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doce_lar/model/models/procedure_model.dart';

class ProcedureListScreen extends StatefulWidget {
  @override
  _ProcedureListScreenState createState() => _ProcedureListScreenState();
}

class _ProcedureListScreenState extends State<ProcedureListScreen> {
  List<Procedure> _procedures = [];
  List<Procedure> _filteredProcedures = [];
  String _searchQuery = '';
  bool _isLoading = false; // Variável para rastrear o estado de carregamento

  @override
  void initState() {
    super.initState();
    _fetchProcedures();
  }

  void _fetchProcedures() async {
    final loginProvider = Provider.of<LoginController>(context, listen: false);
    final procedureRepository = ProcedureRepository();

    setState(() {
      _isLoading = true; // Inicia o carregamento
    });

    try {
      final procedures = await procedureRepository.fetchProcedures(loginProvider.token);
      setState(() {
        _procedures = procedures;
        _filteredProcedures = procedures;
        _isLoading = false; // Finaliza o carregamento
      });
    } catch (e) {
      setState(() {
        _isLoading = false; // Finaliza o carregamento em caso de erro
      });
      // Trate o erro adequadamente
    }
  }

  void _filterProcedures(String query) {
    final filteredProcedures = _procedures.where((procedure) {
      final procedureLower = procedure.name!.toLowerCase();
      final queryLower = query.toLowerCase();
      return procedureLower.contains(queryLower);
    }).toList();

    setState(() {
      _searchQuery = query;
      _filteredProcedures = filteredProcedures;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Procedimentos'),
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
                hintText: 'Pesquisar procedimento...',
                prefixIcon: Icon(Icons.search, color: Colors.green),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: _filterProcedures,
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator()) // Exibe o indicador de progresso enquanto carrega
                : _filteredProcedures.isEmpty
                    ? Center(child: Text('Nenhum procedimento encontrado'))
                    : ListView.builder(
                        itemCount: _filteredProcedures.length,
                        itemBuilder: (context, index) {
                          final procedure = _filteredProcedures[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CustomCard(
                              name: procedure.name.toString(),
                              email: procedure.description.toString(),
                              phone: procedure.dosage.toString(),
                              onTap: () {
                                showProcedureDetailDialog(context, procedure, _fetchProcedures);
                              },
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
