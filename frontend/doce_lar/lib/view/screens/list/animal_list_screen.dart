import 'package:doce_lar/controller/login_controller.dart';
import 'package:doce_lar/model/models/homes_model.dart';
import 'package:doce_lar/model/models/user_model.dart';
import 'package:doce_lar/model/repositories/animals_repository.dart';
import 'package:doce_lar/model/repositories/animals_types_repository.dart';
import 'package:doce_lar/model/repositories/colaborador_repository.dart';
import 'package:doce_lar/model/repositories/homes_repository.dart';
import 'package:doce_lar/view/screens/dialog/details/animal_details_screen.dart';
import 'package:doce_lar/view/widgets/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doce_lar/model/models/animal_model.dart';
import 'package:doce_lar/model/models/animal_type_model.dart';

class AnimalListScreen extends StatefulWidget {
  const AnimalListScreen({super.key});

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

  List<Usuario> _colaboradores = [];
  Usuario? _selectedColaborador;

  List<Home> _homes = [];
  Home? _selectedHome;

  void _fetchHomes(String colaboradorId) async {
    final loginProvider = Provider.of<LoginController>(context, listen: false);
    final homeRepository = HomeRepository();

    try {
      final allHomes = await homeRepository.fetchHomes(loginProvider.token);
      setState(() {
        _homes = allHomes
            .where((home) => home.collaboratorId == colaboradorId)
            .toList();
        // Defina o home selecionado para o primeiro endereço se a lista não estiver vazia
        if (_homes.isNotEmpty) {
          _selectedHome = _homes.first;
        }
      });
    } catch (e) {
      print('Erro ao buscar endereços: $e');
    }
  }

  // Método para buscar colaboradores
  void _fetchColaboradores() async {
    final loginProvider = Provider.of<LoginController>(context, listen: false);
    final colaboradorRepository = ColaboradorRepository();

    try {
      final colaboradores =
          await colaboradorRepository.fetchColaboradores(loginProvider.token);
      setState(() {
        _colaboradores = colaboradores;
        // Defina o colaborador selecionado para o primeiro colaborador se a lista não estiver vazia
        if (_colaboradores.isNotEmpty) {
          _selectedColaborador = _colaboradores.first;
        }
      });
    } catch (e) {
      print('Erro ao buscar colaboradores: $e');
    }
  }

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
    _fetchColaboradores();
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
  String name = '';
  String sex = 'M'; // Default to 'M'
  bool castrated = false;
  String race = '';
  String linkPhoto = '';
  int typeAnimalId = _animalTypes.isNotEmpty ? _animalTypes.first.id ?? 1 : 1; // Default to first type ID if available
  bool status = true;
  Usuario? selectedColaborador = _selectedColaborador;
  Home? selectedHome = _selectedHome;
  final descriptionController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Adicionar Novo Animal'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(labelText: 'Nome'),
                    onChanged: (value) {
                      name = value;
                    },
                  ),
                  DropdownButtonFormField<String>(
                    value: sex,
                    decoration: const InputDecoration(labelText: 'Sexo'),
                    items: const [
                      DropdownMenuItem(value: 'M', child: Text('Macho')),
                      DropdownMenuItem(value: 'F', child: Text('Fêmea')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        sex = value!;
                      });
                    },
                  ),
                  DropdownButtonFormField<int>(
                    value: typeAnimalId,
                    decoration: const InputDecoration(labelText: 'Tipo de Animal'),
                    items: _animalTypes.map((type) {
                      return DropdownMenuItem(
                        value: type.id,
                        child: Text(type.type ?? ''),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        typeAnimalId = value ?? (_animalTypes.isNotEmpty ? _animalTypes.first.id ?? 1 : 1);
                      });
                    },
                  ),
                  DropdownButtonFormField<Usuario>(
                    value: selectedColaborador,
                    decoration: const InputDecoration(labelText: 'Colaborador'),
                    items: _colaboradores.map((colaborador) {
                      return DropdownMenuItem(
                        value: colaborador,
                        child: Text(colaborador.name ?? 'Desconhecido'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedColaborador = value;
                        if (selectedColaborador != null) {
                          _fetchHomes(selectedColaborador!.id ?? '');
                        }
                      });
                    },
                  ),
                  DropdownButtonFormField<Home>(
                    value: selectedHome,
                    decoration: const InputDecoration(labelText: 'Endereço'),
                    items: _homes.map((home) {
                      return DropdownMenuItem(
                        value: home,
                        child: Text('${home.address}, ${home.number}, ${home.city}'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedHome = value;
                      });
                    },
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Raça'),
                    onChanged: (value) {
                      race = value;
                    },
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Link da Foto'),
                    onChanged: (value) {
                      linkPhoto = value;
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Castrado'),
                    value: castrated,
                    onChanged: (value) {
                      setState(() {
                        castrated = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Status'),
                    value: status,
                    onChanged: (value) {
                      setState(() {
                        status = value;
                      });
                    },
                  ),
                  TextField(
                    decoration: const InputDecoration(
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
                child: const Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                child: const Text('Adicionar'),
                onPressed: () async {
                  final loginProvider = Provider.of<LoginController>(context, listen: false);
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
                      homeId: selectedHome?.id, // Adiciona o endereço selecionado
                    );

                    await animalRepository.addAnimal(newAnimal, loginProvider.token);

                    Navigator.of(context).pop(); // Fecha o dialogo de adicionar animal

                    _fetchAnimais(); // Atualiza a lista de animais

                    // Mostrar o dialogo de sucesso
                    _showFeedbackDialog(context, 'Animal adicionado com sucesso', true);
                  } catch (e) {
                    print('Erro ao adicionar animal: $e');

                    // Mostrar o dialogo de erro
                    _showFeedbackDialog(context, 'Erro ao adicionar animal', false);
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


  void _showFeedbackDialog(
      BuildContext context, String message, bool isSuccess) {
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Animais'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/base');
            },
          ),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
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
          backgroundColor: Colors.green,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildAnimalList(bool isActive) {
    // Verifica se o tipo de animal está correto e ajusta a lista filtrada
    List<Animal> animaisParaMostrar =
        isActive ? _activeAnimais : _inactiveAnimais;

    String getSexDescription(String sex) {
      return sex == 'M' ? 'Macho' : 'Fêmea';
    }

    String getAnimalTypeName(int? typeId) {
      final type = _animalTypes.firstWhere(
        (t) => t.id == typeId,
        orElse: () => AnimalType(type: 'Desconhecido'),
      );
      return type.type ?? 'Desconhecido';
    }

    Color getButtonColor(int? typeId) {
      return _selectedTypeId == typeId ? Colors.green : Colors.grey;
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Pesquisar animal...',
              prefixIcon: const Icon(Icons.search, color: Colors.green),
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
                  backgroundColor: getButtonColor(null), // Cor do botão "Todos"
                ),
                child: const Text('Todos'),
              ),
              ..._animalTypes.map((type) {
                return ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _handleTypeSelection(type.id);
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: getButtonColor(type.id),
                  ),
                  child: Text(type.type ?? ''),
                );
              }),
            ],
          ),
        ),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _filteredAnimais.isEmpty
                  ? const Center(child: Text('Nenhum animal encontrado'))
                  : ListView.builder(
                      itemCount: _filteredAnimais.length,
                      itemBuilder: (context, index) {
                        if (index >= _filteredAnimais.length) {
                          return const SizedBox
                              .shrink(); // Retorna um widget vazio se o índice for inválido
                        }
                        final animal = _filteredAnimais[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomCard(
                            title: animal.name.toString(),
                            info1: getAnimalTypeName(
                                animal.typeAnimalId), // Nome do tipo de animal
                            info2: getSexDescription(
                                animal.sex ?? ''), // Descrição do sexo
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
