import 'dart:developer';
import 'dart:io';
import 'package:doce_lar/controller/login_controller.dart';
import 'package:doce_lar/model/models/document_model.dart';
import 'package:doce_lar/model/repositories/upload_repository.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:doce_lar/controller/interceptor_dio.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class UploadScreen extends StatefulWidget {
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  late UploadRepository _uploadRepository;
  List<Document> _uploadedImages = [];

  @override
  void initState() {
    super.initState();
    final loginProvider = Provider.of<LoginController>(context, listen: false);
    final customDio = CustomDio(loginProvider, context);
    _uploadRepository = UploadRepository(customDio);
    _fetchUploadedImages();
  }

  Future<void> _fetchUploadedImages() async {
    try {
      final images = await _uploadRepository.fetchDocuments(); // Assume que esse método existe no repositório
      setState(() {
        _uploadedImages = images;
      });
    } catch (e) {
      log('Erro ao carregar imagens: $e');
    }
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
      _fetchUploadedImages(); // Atualizar a lista de imagens após upload
    } else {
      log('Nenhuma imagem para enviar');
    }
  }

  Future<void> _downloadImage(String imageUrl) async {
    try {
      Dio dio = Dio();
      var response = await dio.download(imageUrl, await _getDownloadPath(imageUrl));
      if (response.statusCode == 200) {
        log('Imagem baixada com sucesso!');
      } else {
        log('Falha no download');
      }
    } catch (e) {
      log('Erro ao fazer o download: $e');
    }
  }

  Future<String> _getDownloadPath(String imageUrl) async {
    final directory = await getExternalStorageDirectory();
    return '${directory!.path}/${imageUrl.split('/').last}';
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
            const SizedBox(height: 20),
            Expanded(
              child: _uploadedImages.isNotEmpty
                  ? GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                      ),
                      itemCount: _uploadedImages.length,
                      itemBuilder: (context, index) {
                        final document = _uploadedImages[index];
                        String imageUrl = 'http://patrick.vps-kinghost.net:7001${document.key!}';
                        return GestureDetector(
                          onTap: () {
                            _showImagePreview(context, imageUrl);
                          },
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    )
                  : Text('Nenhuma imagem enviada.'),
            ),
          ],
        ),
      ),
    );
  }

  void _showImagePreview(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(imageUrl),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _downloadImage(imageUrl),
                child: Text('Baixar Imagem'),
              ),
            ],
          ),
        );
      },
    );
  }
}
