// TODO: Implement the reservations screen.
import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';

class ReservationScreen extends StatelessWidget {
  const ReservationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.navReservations)),
      body: const Center(
        child: Text('Écran Réservations - à venir'),
      ),
    );
  }
}
