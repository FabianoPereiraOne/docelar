import 'package:doce_lar/controller/login_controller.dart';
import 'package:doce_lar/model/repositories/animals_repository.dart';
import 'package:doce_lar/model/repositories/animals_types_repository.dart';
import 'package:doce_lar/view/screens/dialog/details/animal_details_screen.dart';
import 'package:doce_lar/view/widgets/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doce_lar/model/models/animal_model.dart';
import 'package:doce_lar/model/models/animal_type_model.dart';

class AnimalListScreen extends StatefulWidget {
  @override
  _AnimalListScreenState createState() => _AnimalListScreenState();
}

class _AnimalListScreenState extends State<AnimalListScreen>
    with SingleTickerProviderStateMixin {
  List<Animal> _animais = [];
  List<Animal> _activeAnimais = [];
  List<Animal> _inactiveAnimais = [];
  List<AnimalType> _animalTypes = [];
  List<Animal> _filteredAnimais = [];
  String _searchQuery = '';
  bool _isLoading = false;
  int? _selectedTypeId; // ID do tipo de animal selecionado
  bool _showActive = true; // Controla a exibição de animais ativos ou inativos
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController?.addListener(() {
      if (_tabController?.indexIsChanging ?? false) {
        _toggleAnimalStatus(_tabController?.index == 0);
      }
    });
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
        _activeAnimais =
            animais.where((animal) => animal.status ?? false).toList();
        _inactiveAnimais =
            animais.where((animal) => !(animal.status ?? false)).toList();
        _updateFilteredAnimais();
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
      final types =
          await animalTypeRepository.fetchAnimalTypes(loginProvider.token);
      setState(() {
        _animalTypes = types;
      });
    } catch (e) {
      print('Erro ao buscar tipos de animais: $e');
    }
  }

  void _updateFilteredAnimais() {
    setState(() {
      _filteredAnimais =
          _filterAnimaisByType(_showActive ? _activeAnimais : _inactiveAnimais);
    });
  }

  List<Animal> _filterAnimaisByType(List<Animal> animais) {
    if (_selectedTypeId == null) {
      return animais;
    }

    return animais
        .where((animal) => animal.typeAnimalId == _selectedTypeId)
        .toList();
  }

  void _filterAnimais(String query) {
    final filteredAnimais =
        _filterAnimaisByType(_showActive ? _activeAnimais : _inactiveAnimais)
            .where((animal) {
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
      _updateFilteredAnimais();
    });
  }

  void _toggleAnimalStatus(bool showActive) {
    setState(() {
      _showActive = showActive;
      _updateFilteredAnimais();
    });
  }

  void _showAddAnimalDialog() {
    // Initialize state variables
    String name = '';
    String sex = 'M'; // Default to 'M'
    bool castrated = false;
    String race = '';
    String linkPhoto = '';
    int typeAnimalId = _animalTypes.isNotEmpty
        ? _animalTypes.first.id ?? 1
        : 1; // Default to first type ID if available
    bool status = true;
    final descriptionController = TextEditingController();

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
                    DropdownButtonFormField<String>(
                      value: sex,
                      decoration: InputDecoration(labelText: 'Sexo'),
                      items: [
                        DropdownMenuItem(child: Text('Macho'), value: 'M'),
                        DropdownMenuItem(child: Text('Fêmea'), value: 'F'),
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
                          typeAnimalId = value ??
                              (_animalTypes.isNotEmpty
                                  ? _animalTypes.first.id ?? 1
                                  : 1);
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
                    TextField(
                    decoration: InputDecoration(
                      labelText: 'Descrição',
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                    controller: descriptionController,
                    maxLines: 5,
                    minLines: 3,
                    keyboardType: TextInputType.multiline,
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
                    final loginProvider =
                        Provider.of<LoginController>(context, listen: false);
                    final animalRepository = AnimalRepository();

                    try {
                      final newAnimal = Animal(
                          name: name,
                          description: descriptionController.text,
                          sex: sex,
                          castrated: castrated,
                          race: race,
                          linkPhoto: linkPhoto,
                          typeAnimalId: typeAnimalId,
                          createdAt: DateTime.now().toString(),
                          updatedAt: DateTime.now().toString(),
                          dateExit: "0",
                          status: status,
                          homeId: "bafdfb7c-5f37-4755-a920-fd780474915b");

                      await animalRepository.addAnimal(
                          newAnimal, loginProvider.token);

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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Animais'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/base');
            },
          ),
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: 'Ativos'),
              Tab(text: 'Inativos'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildAnimalList(true),
            _buildAnimalList(false),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _showAddAnimalDialog,
          child: Icon(Icons.add),
          backgroundColor: Colors.green,
        ),
      ),
    );
  }

  Widget _buildAnimalList(bool isActive) {
  // Verifica se o tipo de animal está correto e ajusta a lista filtrada
  List<Animal> animaisParaMostrar =
      isActive ? _activeAnimais : _inactiveAnimais;

  String _getSexDescription(String sex) {
    return sex == 'M' ? 'Macho' : 'Fêmea';
  }

  String _getAnimalTypeName(int? typeId) {
    final type = _animalTypes.firstWhere(
      (t) => t.id == typeId,
      orElse: () => AnimalType(type: 'Desconhecido'),
    );
    return type.type ?? 'Desconhecido';
  }

  Color _getButtonColor(int? typeId) {
    return _selectedTypeId == typeId ? Colors.green : Colors.grey;
  }

  return Column(
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
          onChanged: (query) {
            // Atualiza a pesquisa e os animais filtrados
            setState(() {
              _searchQuery = query;
              _filteredAnimais =
                  _filterAnimaisByType(animaisParaMostrar).where((animal) {
                final animalLower = animal.name?.toLowerCase() ?? '';
                final queryLower = query.toLowerCase();
                return animalLower.contains(queryLower);
              }).toList();
            });
          },
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Wrap(
          spacing: 8.0,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _handleTypeSelection(null);
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    _getButtonColor(null), // Cor do botão "Todos"
              ),
              child: Text('Todos'),
            ),
            ..._animalTypes.map((type) {
              return ElevatedButton(
                onPressed: () {
                  setState(() {
                    _handleTypeSelection(type.id);
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _getButtonColor(type.id),
                ),
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
                      if (index >= _filteredAnimais.length) {
                        return SizedBox.shrink(); // Retorna um widget vazio se o índice for inválido
                      }
                      final animal = _filteredAnimais[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomCard(
                          title: animal.name.toString(),
                          info1: _getAnimalTypeName(animal.typeAnimalId), // Nome do tipo de animal
                          info2: _getSexDescription(animal.sex ?? ''), // Descrição do sexo
                          onTap: () {
                            showAnimalDetailDialog(
                                context, animal, _fetchAnimais);
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
