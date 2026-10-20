import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/auth_provider.dart';

class ClientsManagementScreen extends ConsumerWidget {
  const ClientsManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clients = ref
        .watch(authProvider)
        .users
        .where((user) => user.role == 'USER')
        .toList();

    if (clients.isEmpty) {
      return const Center(child: Text('Aucun client inscrit.'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: clients.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final client = clients[index];
        return ListTile(
          leading: const CircleAvatar(child: Icon(Icons.person_outline)),
          title: Text(client.name ?? client.email),
          subtitle: Text(
            [
              client.email,
              if (client.phone != null) client.phone!,
            ].join('\n'),
          ),
          isThreeLine: client.phone != null,
        );
      },
    );
  }
}
