import 'dart:developer';

import 'package:doce_lar/controller/interceptor_dio.dart';
import 'package:doce_lar/controller/login_controller.dart';
import 'package:doce_lar/model/models/user_model.dart';
import 'package:doce_lar/model/repositories/animals_repository.dart';
import 'package:doce_lar/model/repositories/animals_types_repository.dart';
import 'package:doce_lar/model/repositories/colaborador_repository.dart';
import 'package:doce_lar/model/repositories/upload_repository.dart';
import 'package:doce_lar/view/screens/dialog/add/animal_dialog.dart';
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
  List<Animal> _activeAnimais = [];
  List<Animal> _inactiveAnimais = [];
  List<AnimalType> _animalTypes = [];
  List<Animal> _filteredAnimais = [];
  bool _isLoading = false;
  AnimalType? _selectedAnimalType;
  bool _showActive = true;
  TabController? _tabController;
  List<Usuario> _colaboradores = [];
  List<String>? _homeIds; // Alterado para uma lista de IDs de endereços

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    final loginProvider = Provider.of<LoginController>(context, listen: false);
    final customDio = CustomDio(loginProvider, context);
    final animalRepository = AnimalRepository(customDio);
    final animalTypeRepository = AnimalTypeRepository(customDio);
    final colaboradorRepository = ColaboradorRepository(customDio);

    try {
      final animaisFuture = animalRepository.fetchAnimais();
      final typesFuture = animalTypeRepository.fetchAnimalTypes();
      final colaboradoresFuture = colaboradorRepository.fetchColaboradores();

      final animais = await animaisFuture;
      final types = await typesFuture;
      final colaboradores = await colaboradoresFuture;

      // Obter os IDs de todos os endereços do usuário logado (para usuários do tipo USER)
      _homeIds = loginProvider.usuario.type == 'USER'
          ? (loginProvider.usuario.homes)
              ?.whereType<
                  Map<String,
                      dynamic>>() // Filtra apenas os itens que são Map<String, dynamic>
              .map((home) => home['id'] as String)
              .toList()
          : null;
      setState(() {
        _activeAnimais = animais
            .where((animal) =>
                (animal.status ?? false) &&
                (_homeIds == null ||
                    _homeIds!.contains(animal.home!
                        .id))) // Verificando se o ID do animal corresponde a qualquer um dos homes do usuário
            .toList();
        _inactiveAnimais = animais
            .where((animal) =>
                !(animal.status ?? false) &&
                (_homeIds == null ||
                    _homeIds!.contains(
                        animal.home!.id))) // Verificando para inativos
            .toList();
        _animalTypes = types;
        _colaboradores = colaboradores
            .where((colaborador) => colaborador.statusAccount == true)
            .toList();

        _updateFilteredAnimais();
        _isLoading = false;
      });
    } catch (e) {
      log('Erro ao buscar dados: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _updateFilteredAnimais() {
    setState(() {
      _filteredAnimais =
          _filterAnimaisByType(_showActive ? _activeAnimais : _inactiveAnimais);
    });
  }

  List<Animal> _filterAnimaisByType(List<Animal> animais) {
    if (_selectedAnimalType == null) {
      return animais;
    }

    return animais
        .where((animal) => animal.typeAnimal?.id == _selectedAnimalType?.id)
        .toList();
  }

  void _handleTypeSelection(AnimalType? animalType) {
    setState(() {
      _selectedAnimalType = animalType;
      _updateFilteredAnimais();
    });
  }

  void _toggleAnimalStatus(bool showActive) {
    setState(() {
      _showActive = showActive;
      _updateFilteredAnimais();
    });
  }

  void _showAddAnimalDialog() async {
    await showAddAnimalDialog(
      context,
      _colaboradores,
      _animalTypes,
      _fetchData,
    );
  }


  Future<String?> _fetchLastUploadedImage(BuildContext context, Animal animal) async {
  final loginProvider = Provider.of<LoginController>(context, listen: false);
  final customDio = CustomDio(loginProvider, context);
  final uploadRepository = UploadRepository(customDio);

  // Obtém todos os documentos do animal
  final allDocuments = await uploadRepository.fetchDocuments();

  // Filtra os documentos pelo animalId
  final animalDocuments = allDocuments.where((document) => document.animalId == animal.id).toList();

  // Filtra apenas as imagens (presumindo que as imagens tenham chave não nula)
  final imageDocuments = animalDocuments.where((document) => document.key != null).toList();

  if (imageDocuments.isNotEmpty) {
    // Ordena as imagens pela data de criação (decrescente)
    imageDocuments.sort((a, b) => DateTime.parse(b.createdAt!).compareTo(DateTime.parse(a.createdAt!)));
    return imageDocuments.first.key;  // Retorna a chave da última imagem
  }

  return null;  // Caso não tenha imagem
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
    _fetchData();
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
              Navigator.of(context).pushReplacementNamed('/home');
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
    List<Animal> animaisParaMostrar =
        isActive ? _activeAnimais : _inactiveAnimais;

    String getSexDescription(String sex) {
      return sex == 'M' ? 'Macho' : 'Fêmea';
    }

    String getAnimalTypeName(AnimalType? animalType) {
      return animalType?.type ?? 'Desconhecido';
    }

    Color getButtonColor(AnimalType? animalType) {
      return _selectedAnimalType == animalType ? Colors.green : Colors.grey;
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
              setState(() {
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
                  backgroundColor: getButtonColor(null),
                ),
                child: const Text('Todos'),
              ),
              ..._animalTypes.map((type) {
                return ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _handleTypeSelection(type);
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: getButtonColor(type),
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
                        return const SizedBox.shrink();
                      }
                      final animal = _filteredAnimais[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FutureBuilder<String?>(
                          future: _fetchLastUploadedImage(context, animal),  // Obtendo a última imagem
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Text('Erro ao carregar imagem: ${snapshot.error}');
                            } else {
                              String? imageKey = snapshot.data;

                              return CustomCard(
                                title: animal.name.toString(),
                                info1: getAnimalTypeName(animal.typeAnimal),
                                info2: getSexDescription(animal.sex ?? ''),
                                image: imageKey ?? '',  // Se não houver imagem, deixa vazio
                                onTap: () async {
                                  await showAnimalDetailDialog(context, animal,
                                      _animalTypes, _colaboradores, _fetchData);
                                },
                              );
                            }
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
