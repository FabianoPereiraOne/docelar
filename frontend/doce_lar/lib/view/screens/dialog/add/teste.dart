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
      String animalId = '80121b44-08ac-4b85-8060-0ded3fd2ace0';

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
                : SizedBox( width:200, height: 200,child:  Image.file(_image!)),
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
            SizedBox(height: 20),
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
          
          SizedBox(height: 10),
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
          SizedBox(height: 20),
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
