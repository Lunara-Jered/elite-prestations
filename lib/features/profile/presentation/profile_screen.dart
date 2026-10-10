import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

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
                  const Text(
                    'Invité',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Connectez-vous pour profiter de toutes les fonctionnalités',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.gray300,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 16),
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
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ─────────────────────────────────
            // MON COMPTE
            // ─────────────────────────────────
            _SectionTitle(title: 'Mon compte'),
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
            _SectionTitle(title: 'Préférences'),
            const SizedBox(height: 8),
            _MenuGroup(
              items: [
                _MenuItem(
                  icon: Icons.notifications_outlined,
                  title: 'Notifications',
                  trailing: Switch(
                    value: true,
                    onChanged: (v) {},
                    activeThumbColor: isLight
                        ? AppColors.primary
                        : AppColors.white,
                  ),
                ),
                _MenuItem(
                  icon: Icons.language_outlined,
                  title: 'Langue',
                  trailing: const Text(
                    'Français',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 13,
                    ),
                  ),
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ─────────────────────────────────
            // AIDE
            // ─────────────────────────────────
            _SectionTitle(title: 'Aide & informations'),
            const SizedBox(height: 8),
            _MenuGroup(
              items: [
                _MenuItem(
                  icon: Icons.help_outline,
                  title: 'FAQ',
                  onTap: () {},
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
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ─────────────────────────────────
            // DÉCONNEXION
            // ─────────────────────────────────
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.logout, size: 18),
              label: const Text('Se déconnecter'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error),
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
            const SizedBox(height: 24),

            // Version
            Center(
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
