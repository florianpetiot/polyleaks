import 'package:flutter/material.dart';

class PageHistorique extends StatelessWidget {
  const PageHistorique({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique'),
      ),
      body: const Center(
        child: Text('Historique'),
      ),
    );
  }
}
