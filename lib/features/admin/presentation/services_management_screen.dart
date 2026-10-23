import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/currency.dart';
import '../../../providers/services_provider.dart';

class ServicesManagementScreen extends ConsumerWidget {
  const ServicesManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final services = ref.watch(servicesProvider);
    return services.when(
      data: (serviceList) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FilledButton.icon(
            onPressed: () => _showServiceForm(context, ref),
            icon: const Icon(Icons.add),
            label: const Text('Ajouter un service'),
          ),
          const SizedBox(height: 12),
          if (serviceList.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(
                child: Text('Aucun service. Ajoutez votre premier service.'),
              ),
            ),
          for (final service in serviceList)
            Card(
              child: ListTile(
                title: Text(service.name),
                subtitle: Text(
                  '${formatFCFA(service.basePrice)} • ${service.description}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: PopupMenuButton<String>(
                  onSelected: (action) async {
                    if (action == 'edit') {
                      await _showServiceForm(context, ref, service: service);
                    } else if (action == 'delete') {
                      try {
                        await ref
                            .read(servicesProvider.notifier)
                            .deleteService(service.id);
                      } catch (error) {
                        if (context.mounted) {
                          _showError(
                            context,
                            'Impossible de supprimer le service : $error',
                          );
                        }
                      }
                    }
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'edit', child: Text('Modifier')),
                    PopupMenuItem(value: 'delete', child: Text('Supprimer')),
                  ],
                ),
              ),
            ),
        ],
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Impossible de charger les services : $error'),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => ref.invalidate(servicesProvider),
              child: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showServiceForm(
    BuildContext context,
    WidgetRef ref, {
    ServiceModel? service,
  }) async {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: service?.name ?? '');
    final priceController =
        TextEditingController(text: service?.basePrice.toString() ?? '');
    final descriptionController =
        TextEditingController(text: service?.description ?? '');

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(service == null ? 'Nouveau service' : 'Modifier le service'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Nom'),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Le nom est obligatoire.'
                      : null,
                ),
                TextFormField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Prix (FCFA)'),
                  validator: (value) {
                    final price = int.tryParse(value?.trim() ?? '');
                    return price == null || price < 0
                        ? 'Saisissez un prix valide.'
                        : null;
                  },
                ),
                TextFormField(
                  controller: descriptionController,
                  minLines: 2,
                  maxLines: 4,
                  decoration: const InputDecoration(labelText: 'Description'),
                  validator: (value) =>
                      value == null || value.trim().isEmpty
                          ? 'La description est obligatoire.'
                          : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              final name = nameController.text.trim();
              final model = ServiceModel(
                id: service?.id ??
                    DateTime.now().microsecondsSinceEpoch.toString(),
                name: name,
                slug: service?.slug ?? _slugify(name),
                description: descriptionController.text.trim(),
                features: service?.features ?? const [],
                basePrice: int.parse(priceController.text.trim()),
                unit: service?.unit ?? 'forfait',
                imageUrl: service?.imageUrl,
              );
              try {
                if (service == null) {
                  await ref.read(servicesProvider.notifier).addService(model);
                } else {
                  await ref
                      .read(servicesProvider.notifier)
                      .updateService(model);
                }
                if (dialogContext.mounted) Navigator.of(dialogContext).pop();
              } catch (error) {
                if (dialogContext.mounted) {
                  _showError(
                    dialogContext,
                    'Impossible d’enregistrer le service : $error',
                  );
                }
              }
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
  }

  String _slugify(String value) => value
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
      .replaceAll(RegExp(r'^-|-$'), '');

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
