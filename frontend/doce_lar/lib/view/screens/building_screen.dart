import 'package:flutter/material.dart';

class EmDesenvolvimentoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Em Desenvolvimento'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.construction,
              size: 100,
              color: Colors.green,
            ),
            SizedBox(height: 20),
            Text(
              'Esta funcionalidade está em desenvolvimento.',
              style: TextStyle(
                fontSize: 20,
                color: Colors.green,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
