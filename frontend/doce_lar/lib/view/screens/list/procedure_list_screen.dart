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

void _showAddProcedureDialog() {
  // Inicialize as variáveis de estado
  String name = '';
  String description = '';
  String dosage = '';

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Adicionar Novo Procedimento'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: InputDecoration(labelText: 'Nome do Procedimento'),
                    onChanged: (value) {
                      setState(() {
                        name = value;
                      });
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Descrição'),
                    onChanged: (value) {
                      setState(() {
                        description = value;
                      });
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Dosagem'),
                    onChanged: (value) {
                      setState(() {
                        dosage = value;
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
                child: Text('Adicionar'),
                onPressed: () async {
                  final loginProvider = Provider.of<LoginController>(context, listen: false);
                  final procedureRepository = ProcedureRepository();

                  try {
                    final newProcedure = Procedure(
                      name: name,
                      description: description,
                      dosage: dosage,
                    );

                    // Adiciona o novo procedimento
                    await procedureRepository.addProcedure(newProcedure, loginProvider.token);

                    // Atualiza a lista de procedimentos
                    _fetchProcedures();

                    Navigator.of(context).pop();
                    _showFeedbackDialog(context, 'Procedimento adicionado com sucesso!', true);
                  } catch (e) {
                    _showFeedbackDialog(context, 'Erro ao adicionar procedimento: $e', false);
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Procedimentos'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/home');
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
                              title: procedure.name.toString(),
                              info1: procedure.description.toString(),
                              info2: procedure.dosage.toString(),
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
       floatingActionButton: FloatingActionButton(
        onPressed: _showAddProcedureDialog,
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
