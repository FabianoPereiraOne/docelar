import 'package:doce_lar/controller/login_controller.dart';
import 'package:doce_lar/model/repositories/doctor_repository.dart';
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
  List<Doctor> _filteredDoctors = [];
  String _searchQuery = '';
  bool _isLoading = false; // Variável para rastrear o estado de carregamento

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
        _filteredDoctors = doctors;
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
    final filteredDoctors = _doctors.where((doctor) {
      final doctorLower = doctor.name!.toLowerCase();
      final queryLower = query.toLowerCase();
      return doctorLower.contains(queryLower);
    }).toList();

    setState(() {
      _searchQuery = query;
      _filteredDoctors = filteredDoctors;
    });
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
      body: Column(
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
                ? Center(child: CircularProgressIndicator()) // Exibe o indicador de progresso enquanto carrega
                : _filteredDoctors.isEmpty
                    ? Center(child: Text('Nenhum doutor encontrado'))
                    : ListView.builder(
                        itemCount: _filteredDoctors.length,
                        itemBuilder: (context, index) {
                          final doctor = _filteredDoctors[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CustomCard(
                              name: doctor.name.toString(),
                              email: doctor.expertise.toString(),
                              phone: doctor.phone.toString(),
                              onTap: () {
                                showDoctorDetailDialog(
                                  context,
                                  doctor,
                                  _fetchDoctors
                                );
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
