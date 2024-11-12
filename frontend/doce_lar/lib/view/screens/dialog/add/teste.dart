import 'dart:developer';
import 'dart:io';
import 'package:doce_lar/controller/login_controller.dart';
import 'package:doce_lar/model/models/document_model.dart';
import 'package:doce_lar/model/repositories/upload_repository.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:doce_lar/controller/interceptor_dio.dart';
import 'package:provider/provider.dart';

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
    _uploadRepository = UploadRepository(customDio);
  }

  Future<void> _selectImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    } else {
      log('Nenhuma imagem selecionada');
    }
  }

  Future<void> _uploadImage() async {
    if (_image != null) {
      String animalId = 'c9ebaa72-cd70-4dc2-ad60-3025f7caee9d';
      Document document = Document(
        file: _image!,
        animalId: animalId,
      );
      await _uploadRepository.uploadDocument(document);
      log('Upload realizado com sucesso');
    } else {
      log('Nenhuma imagem para enviar');
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
            ElevatedButton(
              onPressed: _selectImage,
              child: Text('Selecionar Imagem'),
            ),
            const SizedBox(height: 20),
            _image != null
                ? SizedBox(
                    width: 200,
                    height: 200,
                    child: Image.file(_image!, fit: BoxFit.cover),
                  )
                : Text('Nenhuma imagem selecionada.'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadImage,
              child: Text('Enviar Imagem'),
            ),
          ],
        ),
      ),
    );
  }
}
