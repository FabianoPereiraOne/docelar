import 'package:doce_lar/controller/cep.dart';
import 'package:doce_lar/controller/login_controller.dart';
import 'package:doce_lar/model/repositories/doctor_repository.dart';
import 'package:doce_lar/utils/masks.dart';
import 'package:doce_lar/view/screens/dialog/details/doctor_details_screen.dart';
import 'package:doce_lar/view/widgets/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doce_lar/model/models/doctor_model.dart';

class DoctorListScreen extends StatefulWidget {
  @override
  _DoctorListScreenState createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  List<Doctor> _doctors = [];
  List<Doctor> _activeDoctors = [];
  List<Doctor> _inactiveDoctors = [];
  List<Doctor> _filteredDoctors = [];
  String _searchQuery = '';
  bool _isLoading = false; // Variável para rastrear o estado de carregamento
  int _selectedTabIndex = 0; // Variável para controlar a aba selecionada

  @override
  void initState() {
    super.initState();
    _fetchDoctors();
  }

  void _fetchDoctors() async {
    final loginProvider = Provider.of<LoginController>(context, listen: false);
    final doctorRepository = DoctorRepository();

    setState(() {
      _isLoading = true; // Inicia o carregamento
    });

    try {
      final doctors = await doctorRepository.fetchDoctors(loginProvider.token);
      setState(() {
        _doctors = doctors;
        _activeDoctors = doctors.where((doctor) => doctor.status!).toList();
        _inactiveDoctors = doctors.where((doctor) => !doctor.status!).toList();
        _filteredDoctors =
            _selectedTabIndex == 0 ? _activeDoctors : _inactiveDoctors;
        _isLoading = false; // Finaliza o carregamento
      });
    } catch (e) {
      setState(() {
        _isLoading = false; // Finaliza o carregamento em caso de erro
      });
      // Trate o erro adequadamente
    }
  }

  void _filterDoctors(String query) {
    final filteredDoctors =
        (_selectedTabIndex == 0 ? _activeDoctors : _inactiveDoctors)
            .where((doctor) {
      final doctorLower = doctor.name!.toLowerCase();
      final queryLower = query.toLowerCase();
      return doctorLower.contains(queryLower);
    }).toList();

    setState(() {
      _searchQuery = query;
      _filteredDoctors = filteredDoctors;
    });
  }

  void _showAddDoctorDialog() {
    // Variáveis de estado para armazenar os dados do médico
    String name = '';
    String crmv = '';
    String expertise = '';
    String phone = '';
    String socialReason = '';
    String cep = '';
    String state = '';
    String city = '';
    String district = '';
    String address = '';
    String number = '';
    String openHours = '';

    // Controladores para os campos de texto
    final TextEditingController _cepController = TextEditingController();
    final TextEditingController _stateController = TextEditingController();
    final TextEditingController _cityController = TextEditingController();
    final TextEditingController _districtController = TextEditingController();
    final TextEditingController _addressController = TextEditingController();

    Future<void> _buscarCep(String cep) async {
      String cepSemHifen = cep.replaceAll('-', '');

      if (cepSemHifen.length == 8) {
        final endereco = await CepService().buscarEnderecoPorCep(cepSemHifen);
        if (endereco != null) {
          _addressController.text = endereco['logradouro'] ?? '';
          _cityController.text = endereco['localidade'] ?? '';
          _stateController.text = endereco['uf'] ?? '';
          _districtController.text = endereco['bairro'] ?? '';
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('CEP inválido ou não encontrado')),
          );
        }
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Adicionar Novo Médico'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: InputDecoration(labelText: 'Nome do Médico'),
                      onChanged: (value) {
                        setState(() {
                          name = value;
                        });
                      },
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'CRMV'),
                      onChanged: (value) {
                        setState(() {
                          crmv = value;
                        });
                      },
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Especialidade'),
                      onChanged: (value) {
                        setState(() {
                          expertise = value;
                        });
                      },
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Telefone'),
                      inputFormatters: [InputMasks.phoneMask],
                      onChanged: (value) {
                        setState(() {
                          phone = value;
                        });
                      },
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Razão Social'),
                      onChanged: (value) {
                        setState(() {
                          socialReason = value;
                        });
                      },
                    ),
                    TextField(
                      controller: _cepController,
                      decoration: InputDecoration(labelText: 'CEP'),
                      inputFormatters: [InputMasks.cepMask],
                      onChanged: (value) {
                        setState(() {
                          cep = value;
                          _buscarCep(value); // Chama a função de busca do CEP
                        });
                      },
                    ),
                    TextField(
                      controller: _stateController,
                      decoration: InputDecoration(labelText: 'Estado'),
                      onChanged: (value) {
                        setState(() {
                          state = value;
                        });
                      },
                    ),
                    TextField(
                      controller: _cityController,
                      decoration: InputDecoration(labelText: 'Cidade'),
                      onChanged: (value) {
                        setState(() {
                          city = value;
                        });
                      },
                    ),
                    TextField(
                      controller: _districtController,
                      decoration: InputDecoration(labelText: 'Bairro'),
                      onChanged: (value) {
                        setState(() {
                          district = value;
                        });
                      },
                    ),
                    TextField(
                      controller: _addressController,
                      decoration: InputDecoration(labelText: 'Endereço'),
                      onChanged: (value) {
                        setState(() {
                          address = value;
                        });
                      },
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Número'),
                      onChanged: (value) {
                        setState(() {
                          number = value;
                        });
                      },
                    ),
                    TextField(
                      decoration: InputDecoration(
                          labelText: 'Horário de Funcionamento'),
                      onChanged: (value) {
                        setState(() {
                          openHours = value;
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
                    final loginProvider =
                        Provider.of<LoginController>(context, listen: false);
                    final doctorRepository = DoctorRepository();

                    try {
                      final newDoctor = Doctor(
                        name: name,
                        crmv: crmv,
                        expertise: expertise,
                        phone: phone,
                        socialReason: socialReason,
                        cep: cep,
                        state: state,
                        city: city,
                        district: district,
                        address: address,
                        number: number,
                        openHours: openHours,
                        status: true,
                      );

                      // Adiciona o novo médico
                      await doctorRepository.addDoctor(
                          newDoctor, loginProvider.token);

                      // Atualiza a lista de médicos ou executa outras ações necessárias
                      _fetchDoctors();

                      Navigator.of(context).pop();
                    } catch (e) {
                      print('Erro ao adicionar médico: $e');
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
        title: Text('Doutores'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/base');
          },
        ),
      ),
      body: DefaultTabController(
        length: 2, // Número de abas
        child: Column(
          children: [
            Container(
              color: Colors.white,
              child: TabBar(
                onTap: (index) {
                  setState(() {
                    _selectedTabIndex = index;
                    _filterDoctors(
                        _searchQuery); // Refiltra a lista ao mudar de aba
                  });
                },
                tabs: [
                  Tab(text: 'Ativos'),
                  Tab(text: 'Inativos'),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Pesquisar doutor...',
                        prefixIcon: Icon(Icons.search, color: Colors.green),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      onChanged: _filterDoctors,
                    ),
                  ),
                  Expanded(
                    child: _isLoading
                        ? Center(child: CircularProgressIndicator())
                        : _filteredDoctors.isEmpty
                            ? Center(child: Text('Nenhum doutor encontrado'))
                            : ListView.builder(
                                itemCount: _filteredDoctors.length,
                                itemBuilder: (context, index) {
                                  final doctor = _filteredDoctors[index];
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CustomCard(
                                      title: doctor.name.toString(),
                                      info1: doctor.expertise.toString(),
                                      info2: doctor.phone.toString(),
                                      onTap: () {
                                        showDoctorDetailDialog(
                                          context,
                                          doctor,
                                          _fetchDoctors,
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDoctorDialog,
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
