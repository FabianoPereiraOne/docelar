import 'package:doce_lar/view/screens/dialog/details/doctor_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:provider/provider.dart';
import 'package:doce_lar/controller/login_controller.dart';
import 'package:doce_lar/model/repositories/doctor_repository.dart';
import 'package:doce_lar/model/models/doctor_model.dart';
import 'package:doce_lar/view/widgets/custom_card.dart';
import 'package:doce_lar/controller/cep.dart';

class DoctorListScreen extends StatefulWidget {
  @override
  _DoctorListScreenState createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  List<Doctor> _doctors = [];
  List<Doctor> _activeDoctors = [];
  List<Doctor> _inactiveDoctors = [];
  String _searchQuery = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchDoctors();
  }

  void _fetchDoctors() async {
    final loginProvider = Provider.of<LoginController>(context, listen: false);
    final doctorRepository = DoctorRepository();

    setState(() {
      _isLoading = true;
    });

    try {
      final doctors = await doctorRepository.fetchDoctors(loginProvider.token);
      setState(() {
        _doctors = doctors;
        _activeDoctors = doctors.where((doctor) => doctor.status!).toList();
        _inactiveDoctors = doctors.where((doctor) => !doctor.status!).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Trate o erro adequadamente
    }
  }

  void _filterDoctors(String query) {
    final filteredDoctors = _doctors.where((doctor) {
      final doctorLower = doctor.name!.toLowerCase();
      final queryLower = query.toLowerCase();
      return doctorLower.contains(queryLower);
    }).toList();

    setState(() {
      _searchQuery = query;
      _activeDoctors =
          filteredDoctors.where((doctor) => doctor.status!).toList();
      _inactiveDoctors =
          filteredDoctors.where((doctor) => !doctor.status!).toList();
    });
  }

void _showAddDoctorDialog() {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController crmvController = TextEditingController();
  final TextEditingController expertiseController = TextEditingController();
  final TextEditingController phoneController =
      MaskedTextController(mask: '(00) 00000-0000');
  final TextEditingController socialReasonController =
      TextEditingController();
  final TextEditingController cepController =
      MaskedTextController(mask: '00000-000');
  final TextEditingController stateController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController openHoursController = TextEditingController();

  Future<void> _buscarCep(String cep) async {
    String cepSemHifen = cep.replaceAll('-', '');

    if (cepSemHifen.length == 8) {
      final endereco = await CepService().buscarEnderecoPorCep(cepSemHifen);
      if (endereco != null) {
        setState(() {
          addressController.text = endereco['logradouro'] ?? '';
          cityController.text = endereco['localidade'] ?? '';
          stateController.text = endereco['uf'] ?? '';
          districtController.text = endereco['bairro'] ?? '';
        });
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
      return AlertDialog(
        title: Text('Adicionar Novo Médico'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Nome do Médico'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Campo obrigatório'
                      : null,
                ),
                TextFormField(
                  controller: crmvController,
                  decoration: InputDecoration(labelText: 'CRMV'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Campo obrigatório'
                      : null,
                ),
                TextFormField(
                  controller: expertiseController,
                  decoration: InputDecoration(labelText: 'Especialidade'),
                ),
                TextFormField(
                  controller: phoneController,
                  decoration: InputDecoration(labelText: 'Telefone'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Campo obrigatório'
                      : null,
                ),
                TextFormField(
                  controller: socialReasonController,
                  decoration: InputDecoration(labelText: 'Razão Social'),
                ),
                TextFormField(
                  controller: cepController,
                  decoration: InputDecoration(labelText: 'CEP'),
                  onChanged: (value) {
                    _buscarCep(value);
                  },
                ),
                TextFormField(
                  controller: stateController,
                  decoration: InputDecoration(labelText: 'Estado'),
                ),
                TextFormField(
                  controller: cityController,
                  decoration: InputDecoration(labelText: 'Cidade'),
                ),
                TextFormField(
                  controller: districtController,
                  decoration: InputDecoration(labelText: 'Bairro'),
                ),
                TextFormField(
                  controller: addressController,
                  decoration: InputDecoration(labelText: 'Endereço'),
                ),
                TextFormField(
                  controller: numberController,
                  decoration: InputDecoration(labelText: 'Número'),
                ),
                TextFormField(
                  controller: openHoursController,
                  decoration:
                      InputDecoration(labelText: 'Horário de Funcionamento'),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState?.validate() ?? false) {
                final loginProvider =
                    Provider.of<LoginController>(context, listen: false);
                final doctorRepository = DoctorRepository();

                final newDoctor = Doctor(
                  name: nameController.text,
                  crmv: crmvController.text,
                  expertise: expertiseController.text,
                  phone: phoneController.text,
                  socialReason: socialReasonController.text,
                  cep: cepController.text,
                  state: stateController.text,
                  city: cityController.text,
                  district: districtController.text,
                  address: addressController.text,
                  number: numberController.text,
                  openHours: openHoursController.text,
                  status: true,
                );

                try {
                  await doctorRepository.addDoctor(
                      newDoctor, loginProvider.token);
                  _fetchDoctors();
                  Navigator.of(context).pop();
                  _showFeedbackDialog(
                      context, 'Médico adicionado com sucesso!', true);
                } catch (e) {
                  _showFeedbackDialog(
                      context, 'Erro ao adicionar médico: $e', false);
                }
              }
            },
            child: Text('Adicionar'),
          ),
        ],
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


  Widget _buildDoctorList(List<Doctor> doctors) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Pesquisar médico...',
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
              : doctors.isEmpty
                  ? Center(child: Text('Nenhum médico encontrado'))
                  : ListView.builder(
                      itemCount: doctors.length,
                      itemBuilder: (context, index) {
                        final doctor = doctors[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomCard(
                            title: doctor.name.toString(),
                            info1: doctor.expertise.toString(),
                            info2: doctor.phone.toString(),
                            onTap: () {
                              showDoctorDetailDialog(context, doctor, _fetchDoctors);
                            },
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Médicos'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/base');
            },
          ),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Ativos'),
              Tab(text: 'Inativos'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildDoctorList(_activeDoctors),
            _buildDoctorList(_inactiveDoctors),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _showAddDoctorDialog,
          backgroundColor: Colors.green,
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
