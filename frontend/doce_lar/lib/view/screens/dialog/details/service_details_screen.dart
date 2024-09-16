import 'package:doce_lar/controller/login_controller.dart';
import 'package:doce_lar/model/models/doctor_model.dart';
import 'package:doce_lar/model/models/procedure_model.dart';
import 'package:doce_lar/model/models/service_model.dart';
import 'package:doce_lar/model/repositories/doctor_repository.dart';
import 'package:doce_lar/model/repositories/procedure_repository.dart';
import 'package:doce_lar/model/repositories/service_repository.dart';
import 'package:doce_lar/view/widgets/format_date.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void showServiceDetailsDialog(BuildContext context, String serviceId, Function() onServiceUpdated) async {
  final loginProvider = Provider.of<LoginController>(context, listen: false);
  final serviceRepository = ServiceRepository();

  // Exibir um indicador de carregamento enquanto os dados do serviço são buscados
  Service? service;
  
  showDialog(
    context: context,
    builder: (context) => Center(child: CircularProgressIndicator()),
  );

  // Buscar o serviço pelo ID
  try {
    service = await serviceRepository.getServiceById(serviceId, loginProvider.token);
    Navigator.of(context).pop(); // Fechar o diálogo de carregamento
  } catch (e) {
    Navigator.of(context).pop(); // Fechar o diálogo de carregamento
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Erro'),
        content: Text('Não foi possível carregar os detalhes do serviço.'),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Fechar'),
          ),
        ],
      ),
    );
    return;
  }

  // Função auxiliar para construir uma lista de nomes a partir de uma lista de objetos
  String _buildNamesList(List<dynamic> items, String Function(dynamic) getName) {
    return items.isEmpty
        ? 'N/A'
        : items.map((item) => getName(item)).join(', ');
  }

  // Exibir os detalhes do serviço após carregar os dados
  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(service!.animal!.name!),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop(); // Fechar o diálogo
                  },
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  // _buildDetailRow('Status', service.status == true ? 'Concluido' : 'Em progresso'),
                  _buildDetailRow('Data de Criação', formatDate(service.createdAt!)),
                  _buildDetailRow('Médicos', _buildNamesList(service.doctors!, (doctor) => doctor.name)),
                  _buildDetailRow('Procedimentos', _buildNamesList(service.procedures!, (procedure) => procedure.name)),

                Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Descrição',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 5),
                                  Container(
                                    width: 300, // Largura fixa
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey, width: 1.0),
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    child: Text(
                                     service.description!,
                                      style: TextStyle(color: Colors.grey[700]),
                                      textAlign: TextAlign.left,
                                      softWrap: true, // Quebrar linhas
                                    ),
                                  ),
                                ],
                              ),
                            ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Fechar o diálogo
                  _showEditServiceDialog(context, service!, onServiceUpdated);
                },
                child: Text('Editar'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Fechar o diálogo
                  _confirmDeleteService(context, service!.id!, onServiceUpdated);
                },
                child: Text('Deletar'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
            ],
          );
        },
      );
    },
  );
}

Widget _buildDetailRow(String label, String? value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Flexible(
          child: Text(
            value ?? 'N/A',
            style: TextStyle(color: Colors.grey[700]),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    ),
  );
}



void _confirmDeleteService(BuildContext context, String serviceId, Function() onServiceDeleted) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Confirmar Exclusão'),
      content: Text('Tem certeza que deseja excluir este serviço?'),
      actions: [
        TextButton(
          child: Text('Cancelar'),
          onPressed: () {
            Navigator.of(context).pop(); // Fechar o diálogo de confirmação
          },
        ),
        ElevatedButton(
          child: Text('Deletar'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () async {
            final loginProvider = Provider.of<LoginController>(context, listen: false);
            final serviceRepository = ServiceRepository();

            try {
              await serviceRepository.deleteService(serviceId, loginProvider.token);
              Navigator.of(context).pop(); // Fechar o diálogo de confirmação
              onServiceDeleted(); // Atualizar a tela principal
            } catch (e) {
              print('Erro ao excluir serviço: $e');
            }
          },
        ),
      ],
    ),
  );
}

void _showEditServiceDialog(BuildContext context, Service service, Function() onServiceUpdated) {
  final TextEditingController descriptionController = TextEditingController(text: service.description ?? '');
  bool status = service.status ?? true;

  // Listas de médicos e procedimentos para selecionar
  List<Doctor> _doctors = [];
  List<Procedure> _procedures = [];
  
  // Seleção atual
  Doctor? _selectedDoctor;
  Procedure? _selectedProcedure;
  
  final loginProvider = Provider.of<LoginController>(context, listen: false);
  
  Future<void> _loadOptions() async {
    final doctorRepository = DoctorRepository();
    final procedureRepository = ProcedureRepository();

    _doctors = await doctorRepository.fetchDoctors(loginProvider.token);
    _procedures = await procedureRepository.fetchProcedures(loginProvider.token);

    // Definir seleção inicial com base no serviço
    _selectedDoctor = _doctors.firstWhere((doc) => doc.id == service.doctors!.first.id, orElse: () => _doctors.first);
    _selectedProcedure = _procedures.firstWhere((proc) => proc.id == service.procedures!.first.id, orElse: () => _procedures.first);
  }

  Future<void> _saveService() async {
    if (_selectedDoctor == null || _selectedProcedure == null) {
      // Exibir mensagem de erro se médico ou procedimento não for selecionado corretamente
      print('Erro: Médico ou Procedimento não selecionado corretamente');
      return;
    }

    final updatedService = Service(
      id: service.id,
      description: descriptionController.text,
      status: status,
      doctors: [_selectedDoctor!],
      procedures: [_selectedProcedure!],
    );

    final serviceRepository = ServiceRepository();
    await serviceRepository.updateService(updatedService, loginProvider.token);
    
    onServiceUpdated(); // Atualizar a tela principal após a edição
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return FutureBuilder(
        future: _loadOptions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return AlertDialog(
              title: Text('Carregando'),
              content: CircularProgressIndicator(),
            );
          }

          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text('Editar Serviço'),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButtonFormField<Doctor>(
                        value: _selectedDoctor,
                        decoration: InputDecoration(
                          labelText: 'Selecionar Médico',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        items: _doctors.map((doctor) {
                          return DropdownMenuItem<Doctor>(
                            value: doctor,
                            child: Text(doctor.name ?? 'Médico ${doctor.id}'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedDoctor = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Por favor, selecione um médico';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      DropdownButtonFormField<Procedure>(
                        value: _selectedProcedure,
                        decoration: InputDecoration(
                          labelText: 'Selecionar Procedimento',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        items: _procedures.map((procedure) {
                          return DropdownMenuItem<Procedure>(
                            value: procedure,
                            child: Text(procedure.name ?? 'Procedimento ${procedure.id}'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedProcedure = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Por favor, selecione um procedimento';
                          }
                          return null;
                        },
                      ),
                      // SizedBox(height: 10),
                      // SwitchListTile(
                      //   title: Text('Status'),
                      //   value: status,
                      //   onChanged: (value) {
                      //     setState(() {
                      //       status = value;
                      //     });
                      //   },
                      // ),
                      SizedBox(height: 10),
                      TextField(
                        controller: descriptionController,
                        decoration: InputDecoration(labelText: 'Descrição'),
                        maxLines: 5,
                        minLines: 3,
                        keyboardType: TextInputType.multiline,
                      ),
                    ],
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
                      await _saveService();
                      Navigator.of(context).pop();
                    },
                    child: Text('Salvar'),
                  ),
                ],
              );
            },
          );
        },
      );
    },
  );
}
