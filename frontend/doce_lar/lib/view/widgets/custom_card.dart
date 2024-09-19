import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final String info1;
  final String info2;
  final VoidCallback onTap;

  const CustomCard({
    super.key,
    required this.title,
    required this.info1,
    required this.info2,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110, // Altura aumentada para acomodar mais informações
      width: MediaQuery.of(context).size.width * 0.85,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 144, 171, 76),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 0.5,
            blurRadius: 2.0,
            offset: const Offset(2.0, 4.0),
          ),
        ],
      ),
      child: Center(
        child: ListTile(
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                info1,
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                info2,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
          trailing: const Icon(Icons.search, color: Colors.grey),
          onTap: onTap,
        ),
      ),
    );
  }
}
