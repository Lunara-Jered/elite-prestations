// TODO: Implement the profile screen.
import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.navProfile)),
      body: const Center(
        child: Text('Écran Profil - à venir'),
      ),
    );
  }
}
