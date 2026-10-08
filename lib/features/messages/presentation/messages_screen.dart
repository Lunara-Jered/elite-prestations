// TODO: Implement the messages screen.
import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.navMessages)),
      body: const Center(
        child: Text('Écran Messages - à venir'),
      ),
    );
  }
}
