import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../providers/auth_provider.dart';
import 'clients_management_screen.dart';
import 'dashboard_screen.dart';
import 'reservations_management_screen.dart';
import 'services_management_screen.dart';

class AdminShell extends ConsumerStatefulWidget {
  const AdminShell({super.key});

  @override
  ConsumerState<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends ConsumerState<AdminShell> {
  int _selectedIndex = 0;

  static const _sections = [
    (title: 'Tableau de bord', icon: Icons.dashboard_outlined),
    (title: 'Réservations', icon: Icons.event_note_outlined),
    (title: 'Services', icon: Icons.room_service_outlined),
    (title: 'Clients', icon: Icons.people_outline),
  ];

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    final screens = [
      const DashboardScreen(),
      const ReservationsManagementScreen(),
      const ServicesManagementScreen(),
      const ClientsManagementScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_sections[_selectedIndex].title),
        actions: [
          IconButton(
            tooltip: 'Quitter l’administration',
            onPressed: () => context.go('/home'),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(user?.name ?? 'Administration'),
                accountEmail: Text(user?.email ?? 'Élite Prestations'),
                currentAccountPicture: const CircleAvatar(
                  child: Icon(Icons.admin_panel_settings_outlined),
                ),
              ),
              for (var index = 0; index < _sections.length; index++)
                ListTile(
                  leading: Icon(_sections[index].icon),
                  title: Text(_sections[index].title),
                  selected: _selectedIndex == index,
                  onTap: () {
                    setState(() => _selectedIndex = index);
                    Navigator.of(context).pop();
                  },
                ),
              const Spacer(),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Retour à l’application'),
                onTap: () => context.go('/home'),
              ),
            ],
          ),
        ),
      ),
      body: IndexedStack(index: _selectedIndex, children: screens),
    );
  }
}
