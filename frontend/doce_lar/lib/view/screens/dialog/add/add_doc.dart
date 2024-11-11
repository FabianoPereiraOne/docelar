import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:doce_lar/model/models/document_model.dart';
import 'package:doce_lar/model/repositories/upload_repository.dart';

class ImageUploadHelper {
  final BuildContext context;
  final UploadRepository uploadRepository;
  final String? animalId;  // animalId opcional
  final String? serviceId; // serviceId opcional

  ImageUploadHelper({
    required this.context,
    required this.uploadRepository,
    this.animalId, // Pode ser nulo
    this.serviceId, // Pode ser nulo
  });

  Future<void> selectAndConfirmImage() async {
    final ImagePicker _picker = ImagePicker();
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File image = File(pickedFile.path);
      _showConfirmationDialog(image);
    } else {
      print('Nenhuma imagem selecionada');
    }
  }

  void _showConfirmationDialog(File image) {
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
                child: Image.file(image, fit: BoxFit.cover),
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
                Navigator.of(context).pop();
                await _uploadImage(image); // Faz o upload da imagem
              },
              child: const Text("Confirmar"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _uploadImage(File image) async {
    if (animalId == null && serviceId == null) {
      print('Nenhum ID de animal ou serviço fornecido');
      return;
    }

    Document document = Document(
      file: image,
      animalId: animalId, // Passa o animalId, se fornecido
      serviceId: serviceId, // Passa o serviceId, se fornecido
    );

    await uploadRepository.uploadDocument(document);
    print('Upload realizado com sucesso');
  }
}
