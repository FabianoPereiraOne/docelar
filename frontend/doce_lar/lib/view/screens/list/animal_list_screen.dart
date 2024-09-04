import 'package:doce_lar/controller/login_controller.dart';
import 'package:doce_lar/model/repositories/animals_repository.dart';
import 'package:doce_lar/model/repositories/animals_types_repository.dart';
import 'package:doce_lar/view/screens/details/animal_detail_screen.dart';
import 'package:doce_lar/view/widgets/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doce_lar/model/models/animal_model.dart';
import 'package:doce_lar/model/models/animal_type_model.dart';

class AnimalListScreen extends StatefulWidget {
  @override
  _AnimalListScreenState createState() => _AnimalListScreenState();
}

class _AnimalListScreenState extends State<AnimalListScreen> {
  List<Animal> _animais = [];
  List<Animal> _filteredAnimais = [];
  List<AnimalType> _animalTypes = [];
  String _searchQuery = '';
  bool _isLoading = false;
  int? _selectedTypeId; // ID do tipo de animal selecionado

  @override
  void initState() {
    super.initState();
    _fetchAnimais();
    _fetchAnimalTypes();
  }

  void _fetchAnimais() async {
    final loginProvider = Provider.of<LoginController>(context, listen: false);
    final animalRepository = AnimalRepository();

    setState(() {
      _isLoading = true;
    });

    try {
      final animais = await animalRepository.fetchAnimais(loginProvider.token);
      setState(() {
        _animais = animais;
        _filteredAnimais = _filterAnimaisByType(animais); // Filtra os animais ao inicializar
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Trate o erro adequadamente
    }
  }

  void _fetchAnimalTypes() async {
    final loginProvider = Provider.of<LoginController>(context, listen: false);
    final animalTypeRepository = AnimalTypeRepository();

    try {
      final types = await animalTypeRepository.fetchAnimalTypes(loginProvider.token);
      setState(() {
        _animalTypes = types;
      });
    } catch (e) {
      print('Erro ao buscar tipos de animais: $e');
    }
  }

  List<Animal> _filterAnimaisByType(List<Animal> animais) {
    if (_selectedTypeId == null) {
      return animais;
    }

    return animais.where((animal) => animal.typeAnimalId == _selectedTypeId).toList();
  }

  void _filterAnimais(String query) {
    final filteredAnimais = _filterAnimaisByType(_animais).where((animal) {
      final animalLower = animal.name?.toLowerCase() ?? '';
      final queryLower = query.toLowerCase();
      return animalLower.contains(queryLower);
    }).toList();

    setState(() {
      _searchQuery = query;
      _filteredAnimais = filteredAnimais;
    });
  }

  void _handleTypeSelection(int? typeId) {
    setState(() {
      _selectedTypeId = typeId;
      _filteredAnimais = _filterAnimaisByType(_animais);
    });
  }

void _showAddAnimalDialog() {
  // Initialize state variables
  String name = '';
  String description = '';
  String sex = 'M'; // Default to 'M'
  bool castrated = false;
  String race = '';
  String linkPhoto = '';
  int typeAnimalId = _animalTypes.isNotEmpty ? _animalTypes.first.id ?? 1 : 1; // Default to first type ID if available
  bool status = true;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Adicionar Novo Animal'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: InputDecoration(labelText: 'Nome'),
                    onChanged: (value) {
                      name = value;
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Descrição'),
                    onChanged: (value) {
                      description = value;
                    },
                  ),
                  DropdownButtonFormField<String>(
                    value: sex,
                    decoration: InputDecoration(labelText: 'Sexo'),
                    items: [
                      DropdownMenuItem(child: Text('Masculino'), value: 'M'),
                      DropdownMenuItem(child: Text('Feminino'), value: 'F'),
                    ],
                    onChanged: (value) {
                      setState(() {
                        sex = value!;
                      });
                    },
                  ),
                  DropdownButtonFormField<int>(
                    value: typeAnimalId,
                    decoration: InputDecoration(labelText: 'Tipo de Animal'),
                    items: _animalTypes.map((type) {
                      return DropdownMenuItem(
                        child: Text(type.type ?? ''),
                        value: type.id,
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        typeAnimalId = value ?? (_animalTypes.isNotEmpty ? _animalTypes.first.id ?? 1 : 1);
                      });
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Raça'),
                    onChanged: (value) {
                      race = value;
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Link da Foto'),
                    onChanged: (value) {
                      linkPhoto = value;
                    },
                  ),
                  SwitchListTile(
                    title: Text('Castrado'),
                    value: castrated,
                    onChanged: (value) {
                      setState(() {
                        castrated = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: Text('Status'),
                    value: status,
                    onChanged: (value) {
                      setState(() {
                        status = value;
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
                  final animalRepository = AnimalRepository();

                  try {
                    final newAnimal = Animal(
                      name: name,
                      description: description,
                      sex: sex,
                      castrated: castrated,
                      race: race,
                      linkPhoto: linkPhoto,
                      typeAnimalId: typeAnimalId,
                      createdAt: DateTime.now().toString(),
                      updatedAt: DateTime.now().toString(),
                      dateExit: "0",
                      status: status,
                      homeId: "bafdfb7c-5f37-4755-a920-fd780474915b"
                    );

                    await animalRepository.addAnimal(newAnimal, loginProvider.token);

                    _fetchAnimais();

                    Navigator.of(context).pop();
                  } catch (e) {
                    print('Erro ao adicionar animal: $e');
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Wrap(
              spacing: 8.0,
              children: [
                ElevatedButton(
                  onPressed: () => _handleTypeSelection(null),
                  child: Text('Todos'),
                ),
                ..._animalTypes.map((type) {
                  return ElevatedButton(
                    onPressed: () => _handleTypeSelection(type.id),
                    child: Text(type.type ?? ''),
                  );
                }).toList(),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _filteredAnimais.isEmpty
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
                              onTap: () {
                                showAnimalDetailDialog(context, animal, () {
                                 _fetchAnimais();
                                });
                              },
                             
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddAnimalDialog,
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}