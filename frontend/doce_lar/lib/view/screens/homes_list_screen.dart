import 'package:doce_lar/controller/login_controller.dart';
import 'package:doce_lar/model/models/homes_model.dart';
import 'package:doce_lar/model/repositories/homes_repository.dart';
import 'package:doce_lar/view/widgets/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeListScreen extends StatefulWidget {
  @override
  _HomeListScreenState createState() => _HomeListScreenState();
}

class _HomeListScreenState extends State<HomeListScreen> {
  List<Home> _homes = [];
  List<Home> _filteredHomes = [];
  String _searchQuery = '';
  bool _isLoading = false; // Variável para rastrear o estado de carregamento

  @override
  void initState() {
    super.initState();
    _fetchHomes();
  }

  void _fetchHomes() async {
    final loginProvider = Provider.of<LoginController>(context, listen: false);
    final homeRepository = HomeRepository();

    setState(() {
      _isLoading = true; // Inicia o carregamento
    });

    try {
      final homes = await homeRepository.fetchHomes(loginProvider.token);
      setState(() {
        _homes = homes;
        _filteredHomes = homes;
        _isLoading = false; // Finaliza o carregamento
      });
    } catch (e) {
      setState(() {
        _isLoading = false; // Finaliza o carregamento em caso de erro
      });
      // Trate o erro adequadamente
    }
  }

  void _filterHomes(String query) {
    final filteredHomes = _homes.where((home) {
      final homeLower = home.address!.toLowerCase();
      final queryLower = query.toLowerCase();
      return homeLower.contains(queryLower);
    }).toList();

    setState(() {
      _searchQuery = query;
      _filteredHomes = filteredHomes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Casas'),
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
                hintText: 'Pesquisar casa...',
                prefixIcon: Icon(Icons.search, color: Colors.green),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: _filterHomes,
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator()) // Exibe o indicador de progresso enquanto carrega
                : _filteredHomes.isEmpty
                    ? Center(child: Text('Nenhuma casa encontrada'))
                    : ListView.builder(
                        itemCount: _filteredHomes.length,
                        itemBuilder: (context, index) {
                          final home = _filteredHomes[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CustomCard(
                              name: home.address.toString(),
                              email: home.city.toString(),
                              phone: home.district.toString(),
                              onTap: () {
                                // Adicione ações ao tocar no card da casa
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
