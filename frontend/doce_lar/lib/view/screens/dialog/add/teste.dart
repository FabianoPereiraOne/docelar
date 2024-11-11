import 'dart:developer';
import 'dart:io';
import 'package:doce_lar/controller/login_controller.dart';
import 'package:doce_lar/model/models/document_model.dart'; // Importe o modelo Document
import 'package:doce_lar/model/repositories/upload_repository.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:doce_lar/controller/interceptor_dio.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';

class UploadScreen extends StatefulWidget {
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  late UploadRepository _uploadRepository;
  List<Document> _documents = []; // Lista para armazenar os documentos obtidos

  @override
  void initState() {
    final loginProvider = Provider.of<LoginController>(context, listen: false);
    final customDio = CustomDio(loginProvider, context);
    super.initState();
    _uploadRepository = UploadRepository(customDio); // Inicializando o UploadRepository com o CustomDio
  }

  Future<void> _selectAndConfirmImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      
      _showConfirmationDialog();
    } else {
      log('Nenhuma imagem selecionada');
    }
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Adicionar imagem:"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: Image.file(_image!, fit: BoxFit.cover),
              ),
              const SizedBox(height: 10),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo sem fazer upload
              },
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Fecha o diálogo
                await _uploadImage(); // Faz o upload da imagem
              },
              child: const Text("Confirmar"),
            ),
          ],
        );
      },
    );
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
      log('Nenhuma imagem selecionada');
    }
  }

  // Função para buscar os documentos da API e atualizar a lista
  Future<void> _fetchDocuments() async {
    try {
      List<Document> documents = await _uploadRepository.fetchDocuments();
      setState(() {
        _documents = documents;
      });
    } catch (e) {
      log('Erro ao buscar documentos: $e');
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
                : SizedBox(width: 200, height: 200, child: Image.file(_image!)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _selectAndConfirmImage,
              child: Text('Selecionar e Adicionar Imagem'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _fetchDocuments,
              child: Text('Exibir Imagens Enviadas'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _documents.length,
                itemBuilder: (context, index) {
                  final document = _documents[index];
                  final imageUrl = 'http://patrick.vps-kinghost.net:7001${document.key}';
                  return Column(
                    children: [
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (_) => Dialog(
                              child: Stack(
                                children: [
                                  PhotoView(
                                    imageProvider: NetworkImage(imageUrl),
                                    minScale: PhotoViewComputedScale.contained,
                                    maxScale: PhotoViewComputedScale.covered * 2,
                                    heroAttributes: PhotoViewHeroAttributes(tag: imageUrl),
                                  ),
                                  Positioned(
                                    top: 40,
                                    right: 20,
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop(); // Fecha o diálogo
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        child: Image.network(
                          imageUrl,
                          height: 150, // Tamanho da imagem na lista
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
