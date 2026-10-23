import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/services/local_storage_service.dart';
import '../../../providers/auth_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    final settings =
        ref.read(localStorageServiceProvider).readObject('profile_settings');
    _notificationsEnabled =
        settings?['notificationsEnabled'] as bool? ?? true;
  }

  Future<void> _setNotificationsEnabled(bool enabled) async {
    final previousValue = _notificationsEnabled;
    setState(() => _notificationsEnabled = enabled);
    try {
      await ref.read(localStorageServiceProvider).saveObject(
        'profile_settings',
        {'notificationsEnabled': enabled},
      );
    } catch (error) {
      if (mounted) {
        setState(() => _notificationsEnabled = previousValue);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Impossible d’enregistrer ce réglage : $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final user = ref.watch(authProvider).user;

    return Scaffold(
      appBar: AppBar(title: const Text('Mon profil')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ─────────────────────────────────
            // EN-TÊTE PROFIL
            // ─────────────────────────────────
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppColors.blackGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 40,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user?.name ?? 'Invité',
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ??
                        'Connectez-vous pour profiter de toutes les fonctionnalités',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.gray300,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (user == null)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => context.go('/sign-in'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.white,
                          foregroundColor: AppColors.primary,
                          minimumSize: const Size(0, 44),
                        ),
                        child: const Text('Se connecter'),
                      ),
                    )
                  else if (user.isAdmin)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => context.go('/admin'),
                        icon: const Icon(Icons.dashboard_outlined),
                        label: const Text('Espace administration'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.white,
                          foregroundColor: AppColors.primary,
                          minimumSize: const Size(0, 44),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ─────────────────────────────────
            // MON COMPTE
            // ─────────────────────────────────
            const _SectionTitle(title: 'Mon compte'),
            const SizedBox(height: 8),
            _MenuGroup(
              items: [
                _MenuItem(
                  icon: Icons.calendar_today_outlined,
                  title: 'Mes réservations',
                  onTap: () => context.go('/reservations'),
                ),
                _MenuItem(
                  icon: Icons.receipt_long_outlined,
                  title: 'Mes factures',
                  onTap: () => context.go('/invoices'),
                ),
                _MenuItem(
                  icon: Icons.description_outlined,
                  title: 'Mes devis',
                  onTap: () => context.go('/devis'),
                ),
                _MenuItem(
                  icon: Icons.room_service_outlined,
                  title: 'Réserver un service',
                  onTap: () => context.go('/booking'),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ─────────────────────────────────
            // PRÉFÉRENCES
            // ─────────────────────────────────
            const _SectionTitle(title: 'Préférences'),
            const SizedBox(height: 8),
            _MenuGroup(
              items: [
                _MenuItem(
                  icon: Icons.notifications_outlined,
                  title: 'Notifications',
                  trailing: Switch(
                    value: _notificationsEnabled,
                    onChanged: _setNotificationsEnabled,
                    activeThumbColor: isLight
                        ? AppColors.primary
                        : AppColors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ─────────────────────────────────
            // AIDE
            // ─────────────────────────────────
            const _SectionTitle(title: 'Aide & informations'),
            const SizedBox(height: 8),
            _MenuGroup(
              items: [
                _MenuItem(
                  icon: Icons.help_outline,
                  title: 'FAQ',
                  onTap: () => _showInfoDialog(
                    context,
                    'Questions fréquentes',
                    'Pour une réservation, choisissez une prestation et suivez les étapes du formulaire. '
                        'Pour toute autre demande, écrivez-nous dans la messagerie.',
                  ),
                ),
                _MenuItem(
                  icon: Icons.chat_bubble_outline,
                  title: 'Contacter WhatsApp',
                  onTap: () {
                    context.go('/messages');
                  },
                ),
                _MenuItem(
                  icon: Icons.info_outline,
                  title: 'À propos',
                  trailing: const Text(
                    'v1.0.0',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 13,
                    ),
                  ),
                  onTap: () => _showInfoDialog(
                    context,
                    'Élite Prestations',
                    'Prestations multiservices et location de matériels à Libreville, Gabon.',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Ajoute ce bouton juste avant le bouton "Se déconnecter"
            ElevatedButton.icon(
              onPressed: () => context.go('/admin/dashboard'),
              icon: const Icon(Icons.admin_panel_settings),
              label: const Text('Accéder au Dashboard Admin'),
            ),
            const SizedBox(height: 16),
            // ─────────────────────────────────
            // DÉCONNEXION
            // ─────────────────────────────────
            OutlinedButton.icon(
              onPressed: user == null
                  ? () => context.go('/sign-in')
                  : () async {
                      try {
                        await ref.read(authProvider.notifier).signOut();
                        if (context.mounted) context.go('/sign-in');
                      } catch (error) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Impossible de se déconnecter : $error'),
                            ),
                          );
                        }
                      }
                    },
              icon: const Icon(Icons.logout, size: 18),
              label: Text(user == null ? 'Se connecter' : 'Se déconnecter'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error),
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
            const SizedBox(height: 24),

            // Version
            const Center(
              child: Text(
                'ÉLITE PRESTATIONS • Le Meilleur Pour Vous',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textMuted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showInfoDialog(BuildContext context, String title, String message) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// HELPERS
// ─────────────────────────────────────────
class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textMuted,
              fontSize: 12,
              letterSpacing: 0.5,
            ),
      ),
    );
  }
}

class _MenuGroup extends StatelessWidget {
  final List<_MenuItem> items;
  const _MenuGroup({required this.items});

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Container(
      decoration: BoxDecoration(
        color: isLight ? AppColors.surface : AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isLight ? AppColors.border : AppColors.borderDark,
        ),
      ),
      child: Column(
        children: List.generate(items.length * 2 - 1, (index) {
          if (index.isOdd) {
            return Divider(
              height: 1,
              thickness: 1,
              color: isLight ? AppColors.border : AppColors.borderDark,
              indent: 56,
            );
          }
          return items[index ~/ 2];
        }),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            if (trailing != null)
              trailing!
            else
              const Icon(
                Icons.chevron_right,
                size: 20,
                color: AppColors.textMuted,
              ),
          ],
        ),
      ),
    );
  }
}
