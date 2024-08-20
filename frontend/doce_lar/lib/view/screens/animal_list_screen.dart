import 'package:doce_lar/controller/login_controller.dart';
import 'package:doce_lar/model/repositories/animals_repository.dart';
import 'package:doce_lar/view/widgets/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doce_lar/model/models/animal_model.dart';

class AnimalListScreen extends StatefulWidget {
  @override
  _AnimalListScreenState createState() => _AnimalListScreenState();
}

class _AnimalListScreenState extends State<AnimalListScreen> {
  List<Animal> _animais = [];
  List<Animal> _filteredAnimais = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchAnimais();
  }

  void _fetchAnimais() async {
    final loginProvider = Provider.of<LoginController>(context, listen: false);
    final animalRepository = AnimalRepository();

    try {
      final animais = await animalRepository.fetchAnimais(loginProvider.token);
      setState(() {
        _animais = animais;
        _filteredAnimais = animais;
      });
    } catch (e) {
      // Trate o erro adequadamente
    }
  }

  void _filterAnimais(String query) {
    final filteredAnimais = _animais.where((animal) {
      final animalLower = animal.name!.toLowerCase();
      final queryLower = query.toLowerCase();
      return animalLower.contains(queryLower);
    }).toList();

    setState(() {
      _searchQuery = query;
      _filteredAnimais = filteredAnimais;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Animais'),
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
                hintText: 'Pesquisar animal...',
                prefixIcon: Icon(Icons.search, color: Colors.green),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: _filterAnimais,
            ),
          ),
          Expanded(
            child: _filteredAnimais.isEmpty
                ? Center(child: Text('Nenhum animal encontrado'))
                : ListView.builder(
                    itemCount: _filteredAnimais.length,
                    itemBuilder: (context, index) {
                      final animal = _filteredAnimais[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomCard(
                          name: animal.name.toString(),
                          email: animal.race.toString(),
                          phone: animal.description.toString(),
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
