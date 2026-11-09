import 'package:flutter/material.dart';

class ProviderLabScreen extends StatelessWidget {
  const ProviderLabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider Lab'),
      ),
      body: const Center(
        child: Text(
          'Provider Lab – đang xây dựng',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
