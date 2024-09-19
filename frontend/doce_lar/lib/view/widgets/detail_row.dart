import 'package:flutter/material.dart';

class DetailRow extends StatelessWidget {
  final String label;
  final String? value;

  const DetailRow({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.bold),
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
        ),
        const Divider(), // Linha abaixo do detalhe
      ],
    );
  }
}
