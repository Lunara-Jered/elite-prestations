// TODO: Implement the services screen.
import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.navServices)),
      body: const Center(
        child: Text('Écran Services - à venir'),
      ),
    );
  }
}
