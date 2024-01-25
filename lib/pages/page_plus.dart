import 'package:flutter/material.dart';

class PagePlus extends StatelessWidget {
  const PagePlus({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plus'),
      ),
      body: const Center(
        child: Text('Plus'),
      ),
    );
  }
}