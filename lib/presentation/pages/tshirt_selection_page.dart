import 'package:flutter/material.dart';

class TshirtSelectionPage extends StatelessWidget {
  const TshirtSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick Your T-shirt'),
      ),
      body: const Center(
        child: Text('T-shirt Selection Page'),
      ),
    );
  }
}
