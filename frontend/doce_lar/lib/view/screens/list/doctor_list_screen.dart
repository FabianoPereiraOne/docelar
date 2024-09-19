import 'package:doce_lar/view/screens/dialog/add/doctor_dialog.dart';
import 'package:doce_lar/view/screens/dialog/details/doctor_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doce_lar/controller/login_controller.dart';
import 'package:doce_lar/model/repositories/doctor_repository.dart';
import 'package:doce_lar/model/models/doctor_model.dart';
import 'package:doce_lar/view/widgets/custom_card.dart';


class DoctorListScreen extends StatefulWidget {
  @override
  _DoctorListScreenState createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  List<Doctor> _doctors = [];
  List<Doctor> _activeDoctors = [];
  List<Doctor> _inactiveDoctors = [];
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
      _activeDoctors =
          filteredDoctors.where((doctor) => doctor.status!).toList();
      _inactiveDoctors =
          filteredDoctors.where((doctor) => !doctor.status!).toList();
    });
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
                              showDoctorDetailDialog(
                                  context, doctor, _fetchDoctors);
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
              Navigator.of(context).pushReplacementNamed('/home');
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
          onPressed: () {
            showAddDoctorDialog(context, _fetchDoctors);
          },
          backgroundColor: Colors.green,
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
