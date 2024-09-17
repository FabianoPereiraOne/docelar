import 'package:flutter/material.dart';

class TopSnackBar {
  static void show(BuildContext context, String message, bool isSuccess) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: SafeArea(
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: isSuccess ? Colors.green : Colors.red,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width - 20, // Largura máxima
                ),
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.visible, // Garante que o texto quebra linhas
                ),
              ),
            ),
          ),
        ),
      ),
    );

    // Adiciona o overlay à tela
    overlay.insert(overlayEntry);

    // Remove o overlay depois de alguns segundos
    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }
}
