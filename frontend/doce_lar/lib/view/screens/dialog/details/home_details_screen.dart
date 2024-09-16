
import 'package:doce_lar/controller/cep.dart';
import 'package:doce_lar/controller/login_controller.dart';
import 'package:doce_lar/model/models/homes_model.dart';
import 'package:doce_lar/model/repositories/homes_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:provider/provider.dart';

void showHomeDetailDialog(BuildContext context, Home home, Function() onHomeUpdated) async {

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(home.address ?? 'Detalhes da Casa'),
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
                crossAxisAlignment: CrossAxisAlignment.start, // Alinha o conteúdo à esquerda
                children: [
                  SizedBox(height: 20),
                  _buildDetailRow('CEP', home.cep),
                  _buildDetailRow('Estado', home.state),
                  _buildDetailRow('Cidade', home.city),
                  _buildDetailRow('Bairro', home.district),
                  _buildDetailRow('Endereço', home.address),
                  _buildDetailRow('Número', home.number),
                  _buildDetailRow('Status', home.status == true ? 'Ativo' : 'Inativo'),

                ],
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Fechar o diálogo
                  _showEditHomeDialog(context, home, onHomeUpdated);
                },
                child: Text('Editar'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Fechar o diálogo
                  _confirmDeleteHome(context, home.id!, onHomeUpdated);
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

void _confirmDeleteHome(BuildContext context, String homeId, Function() onHomeDeleted) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Confirmar Exclusão'),
      content: Text('Tem certeza que deseja excluir esta casa?'),
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
            final homeRepository = HomeRepository();

            try {
              await homeRepository.deleteHome(homeId, loginProvider.token);
              Navigator.of(context).pop(); // Fechar o diálogo de confirmação
              onHomeDeleted(); // Atualizar a tela principal
            } catch (e) {
              print('Erro ao excluir casa: $e');
            }
          },
        ),
      ],
    ),
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

void _showEditHomeDialog(BuildContext context, Home home, Function() onHomeUpdated) {
  final TextEditingController cepController = MaskedTextController(mask: '00000-000', text: home.cep ?? '');
  final TextEditingController stateController = TextEditingController(text: home.state ?? '');
  final TextEditingController cityController = TextEditingController(text: home.city ?? '');
  final TextEditingController districtController = TextEditingController(text: home.district ?? '');
  final TextEditingController addressController = TextEditingController(text: home.address ?? '');
  final TextEditingController numberController = TextEditingController(text: home.number ?? '');

  bool status = home.status ?? true;

  // Adicione o listener para buscar o CEP automaticamente
  cepController.addListener(() async {
    String cep = cepController.text.replaceAll('-', '');
    if (cep.length == 8) {
      await _buscarCep(cep, stateController, cityController, districtController, addressController);
    }
  });

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Editar Casa'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: InputDecoration(labelText: 'CEP'),
                    controller: cepController,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Estado'),
                    controller: stateController,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Cidade'),
                    controller: cityController,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Bairro'),
                    controller: districtController,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Endereço'),
                    controller: addressController,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Número'),
                    controller: numberController,
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
                child: Text('Salvar'),
                onPressed: () async {
                  final loginProvider = Provider.of<LoginController>(context, listen: false);
                  final homeRepository = HomeRepository();

                  try {
                    final updatedHome = Home(
                      id: home.id,
                      cep: cepController.text,
                      state: stateController.text,
                      city: cityController.text,
                      district: districtController.text,
                      address: addressController.text,
                      number: numberController.text,
                      status: status,
                    );

                    await homeRepository.updateHome(updatedHome, loginProvider.token);

                    Navigator.of(context).pop(); // Fechar o diálogo de edição
                    onHomeUpdated(); // Atualizar a tela principal
                  } catch (e) {
                    print('Erro ao editar casa: $e');
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

Future<void> _buscarCep(String cep, TextEditingController stateController, TextEditingController cityController, TextEditingController districtController, TextEditingController addressController) async {
  try {
    String cepSemHifen = cep.replaceAll('-', '');

    if (cepSemHifen.length == 8) {
      final endereco = await CepService().buscarEnderecoPorCep(cepSemHifen);
      if (endereco != null) {
        addressController.text = endereco['logradouro'] ?? '';
        cityController.text = endereco['localidade'] ?? '';
        stateController.text = endereco['uf'] ?? '';
        districtController.text = endereco['bairro'] ?? '';
      } else {
        
        
      }
    }
  } catch (e) {
    print('Erro ao buscar CEP: $e');
  }
}
