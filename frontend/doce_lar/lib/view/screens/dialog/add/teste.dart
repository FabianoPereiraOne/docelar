import 'dart:developer';
import 'dart:io';
import 'package:doce_lar/controller/login_controller.dart';
import 'package:doce_lar/model/repositories/upload_repository.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:doce_lar/controller/interceptor_dio.dart';
import 'package:provider/provider.dart'; // Certifique-se de que o CustomDio é importado corretamente

class UploadScreen extends StatefulWidget {
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  late UploadRepository _uploadRepository;

  @override
  void initState() {
    final loginProvider = Provider.of<LoginController>(context, listen: false);
    final customDio = CustomDio(loginProvider, context);
    super.initState();
    _uploadRepository = UploadRepository(
        customDio); // Inicializando o UploadRepository com o CustomDio
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_image != null) {
      await _uploadRepository.uploadImage(_image!);
    } else {
      log('Nenhuma imagem selecionada');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload de Imagem'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image == null
                ? Text('Nenhuma imagem selecionada.')
                : Image.file(_image!),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Selecionar Imagem'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadImage,
              child: Text('Fazer Upload'),
            ),
          ],
        ),
      ),
    );
  }
}
