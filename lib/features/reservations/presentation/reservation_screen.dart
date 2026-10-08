import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../providers/reservations_provider.dart';
import '../../../shared/models/reservation_model.dart';
import '../../../shared/widgets/status_badge.dart';
import 'widgets/reservation_card.dart';

class ReservationScreen extends ConsumerStatefulWidget {
  const ReservationScreen({super.key});

  @override
  ConsumerState<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends ConsumerState<ReservationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes réservations'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'En cours'),
            Tab(text: 'Passées'),
            Tab(text: 'Annulées'),
          ],
          labelColor: isLight ? AppColors.primary : AppColors.white,
          unselectedLabelColor: AppColors.textMuted,
          indicatorColor: isLight ? AppColors.primary : AppColors.white,
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: const [
            _ReservationList(type: _ListType.active),
            _ReservationList(type: _ListType.past),
            _ReservationList(type: _ListType.cancelled),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/booking');
        },
        backgroundColor: isLight ? AppColors.primary : AppColors.white,
        foregroundColor: isLight ? AppColors.white : AppColors.primary,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

enum _ListType { active, past, cancelled }

class _ReservationList extends ConsumerWidget {
  final _ListType type;
  const _ReservationList({required this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reservations = switch (type) {
      _ListType.active => ref.watch(activeReservationsProvider),
      _ListType.past => ref.watch(pastReservationsProvider),
      _ListType.cancelled => ref.watch(cancelledReservationsProvider),
    };

    if (reservations.isEmpty) {
      return _EmptyState(type: type);
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: reservations.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return ReservationCard(
          reservation: reservations[index],
          onTap: () {
            context.go('/reservations/${reservations[index].id}');
          },
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  final _ListType type;
  const _EmptyState({required this.type});

  @override
  Widget build(BuildContext context) {
    final (icon, title, subtitle) = switch (type) {
      _ListType.active => (
          Icons.event_note_outlined,
          'Aucune réservation en cours',
          'Vos prochaines réservations apparaîtront ici',
        ),
      _ListType.past => (
          Icons.history,
          'Aucune réservation passée',
          'Votre historique apparaîtra ici',
        ),
      _ListType.cancelled => (
          Icons.cancel_outlined,
          'Aucune réservation annulée',
          'Vos annulations apparaîtront ici',
        ),
    };

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: AppColors.textMuted),
          const SizedBox(height: 16),
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textMuted,
                ),
          ),
        ],
      ),
    );
  }
}
