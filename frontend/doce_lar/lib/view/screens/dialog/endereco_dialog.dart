// endereco_dialog.dart
import 'package:doce_lar/model/models/homes_model.dart';
import 'package:doce_lar/model/repositories/homes_repository.dart';
import 'package:flutter/material.dart';
import 'package:doce_lar/controller/cep.dart';
import 'package:doce_lar/controller/login_controller.dart';
import 'package:provider/provider.dart';
import 'package:doce_lar/utils/masks.dart';

void showEnderecoDialog(BuildContext context, String colaboradorId) {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _ruaController = TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();
  final TextEditingController _estadoController = TextEditingController();
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();
  final loginProvider = Provider.of<LoginController>(context, listen: false);

  Future<void> _buscarCep(String cep) async {
    String cepSemHifen = cep.replaceAll('-', '');

    if (cepSemHifen.length == 8) {
      final endereco = await CepService().buscarEnderecoPorCep(cepSemHifen);
      if (endereco != null) {
        _ruaController.text = endereco['logradouro'] ?? '';
        _cidadeController.text = endereco['localidade'] ?? '';
        _estadoController.text = endereco['uf'] ?? '';
        _districtController.text = endereco['bairro'] ?? '';
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('CEP inválido ou não encontrado')),
        );
      }
    }
  }

  Future<void> _addEndereco() async {
    if (_formKey.currentState?.validate() ?? false) {
      final newHome = Home(
        cep: _cepController.text,
        state: _estadoController.text,
        city: _cidadeController.text,
        district: _districtController.text,
        address: _ruaController.text,
        number: _numeroController.text,
        status: true,
        collaboratorId: colaboradorId,
      );

      final homeRepository = HomeRepository();
      await homeRepository.addHome(newHome, loginProvider.token);
    }
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Adicionar Endereço'),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  inputFormatters: [InputMasks.cepMask],
                  controller: _cepController,
                  decoration: InputDecoration(
                    labelText: 'CEP',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: _buscarCep, // Chama a função ao digitar o CEP
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira um CEP';
                    } else if (value.length != 9) {
                      return 'O CEP deve ter 8 dígitos';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _estadoController,
                  decoration: InputDecoration(
                    labelText: 'Estado',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira um estado';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _cidadeController,
                  decoration: InputDecoration(
                    labelText: 'Cidade',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira uma cidade';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _districtController,
                  decoration: InputDecoration(
                    labelText: 'Bairro',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira um bairro';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _ruaController,
                  decoration: InputDecoration(
                    labelText: 'Rua',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira uma rua';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _numeroController,
                  decoration: InputDecoration(
                    labelText: 'Número',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira um número';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await _addEndereco();
              Navigator.of(context).pop();
              showEnderecoDialog(context, colaboradorId);
            },
            child: Text('Novo endereço'),
          ),
          TextButton(
            onPressed: () async {
              await _addEndereco();
              Navigator.of(context).pop();
            },
            child: Text('Concluir'),
          ),
        ],
      );
    },
  );
}
