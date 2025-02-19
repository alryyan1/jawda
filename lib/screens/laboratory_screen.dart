import 'package:flutter/material.dart';

class LaboratoryScreen extends StatelessWidget {
  const LaboratoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laboratory'),
      ),
      body: const Center(
        child: Text('Laboratory Page Content'),
      ),
    );
  }
}