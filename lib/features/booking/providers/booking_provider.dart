// TODO: Implement booking state and actions.
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/services_provider.dart';

/// Modèle d'une option additionnelle
class BookingOption {
  final String id;
  final String name;
  final String iconName; // ← nom d'icône Material (ex: 'restaurant')
  final int unitPrice;
  final bool perPerson;
  final int quantity;

  const BookingOption({
    required this.id,
    required this.name,
    required this.iconName,
    required this.unitPrice,
    this.perPerson = false,
    this.quantity = 0,
  });

  int get total => unitPrice * quantity;

  BookingOption copyWith({int? quantity}) {
    return BookingOption(
      id: id,
      name: name,
      iconName: iconName,
      unitPrice: unitPrice,
      perPerson: perPerson,
      quantity: quantity ?? this.quantity,
    );
  }
}

/// État du parcours de réservation
class BookingState {
  final int currentStep; // 1 à 5
  final ServiceModel? selectedService;
  final DateTime? startDate;
  final DateTime? endDate;
  final int duration; // en jours
  final int guests;
  final List<BookingOption> options;
  final String? paymentMethod;

  const BookingState({
    this.currentStep = 1,
    this.selectedService,
    this.startDate,
    this.endDate,
    this.duration = 1,
    this.guests = 1,
    this.options = const [],
    this.paymentMethod,
  });

  // ─────────────────────────────────────────
  // CALCULS
  // ─────────────────────────────────────────

  /// Sous-total HT
  int get subtotalHT {
    if (selectedService == null) return 0;

    int serviceTotal = selectedService!.basePrice;
    if (selectedService!.unit == 'jour' || selectedService!.unit == 'nuit') {
      serviceTotal = selectedService!.basePrice * duration;
    }

    final optionsTotal = options.fold(0, (sum, o) => sum + o.total);

    return serviceTotal + optionsTotal;
  }

  /// TVA (18% au Gabon)
  int get tva => (subtotalHT * 0.18).round();

  /// Total TTC
  int get totalTTC => subtotalHT + tva;

  /// Acompte (50%)
  int get deposit => (totalTTC * 0.5).round();

  BookingState copyWith({
    int? currentStep,
    ServiceModel? selectedService,
    DateTime? startDate,
    DateTime? endDate,
    int? duration,
    int? guests,
    List<BookingOption>? options,
    String? paymentMethod,
  }) {
    return BookingState(
      currentStep: currentStep ?? this.currentStep,
      selectedService: selectedService ?? this.selectedService,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      duration: duration ?? this.duration,
      guests: guests ?? this.guests,
      options: options ?? this.options,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }

  /// Vérifie si l'étape actuelle est complète
  bool get isCurrentStepValid {
    switch (currentStep) {
      case 1:
        return selectedService != null;
      case 2:
        return startDate != null && duration > 0;
      case 3:
        return true;
      case 4:
        return true;
      case 5:
        return paymentMethod != null;
      default:
        return false;
    }
  }
}

/// Notifier du booking (API moderne Riverpod 2.x)
class BookingNotifier extends Notifier<BookingState> {
  @override
  BookingState build() => const BookingState();

  void nextStep() {
    if (state.currentStep < 5 && state.isCurrentStepValid) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void previousStep() {
    if (state.currentStep > 1) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  void goToStep(int step) {
    if (step >= 1 && step <= 5) {
      state = state.copyWith(currentStep: step);
    }
  }

  void selectService(ServiceModel service) {
    state = state.copyWith(selectedService: service);
  }

  void setDates(DateTime start, DateTime end) {
    final days = end.difference(start).inDays + 1;
    state = state.copyWith(
      startDate: start,
      endDate: end,
      duration: days > 0 ? days : 1,
    );
  }

  void setDuration(int days) {
    state = state.copyWith(duration: days);
  }

  void setGuests(int guests) {
    state = state.copyWith(guests: guests);
  }

  void addOption(BookingOption option) {
    final existing = state.options.indexWhere((o) => o.id == option.id);
    if (existing >= 0) {
      final updated = [...state.options];
      updated[existing] = option;
      state = state.copyWith(options: updated);
    } else {
      state = state.copyWith(options: [...state.options, option]);
    }
  }

  void removeOption(String optionId) {
    state = state.copyWith(
      options: state.options.where((o) => o.id != optionId).toList(),
    );
  }

  void setPaymentMethod(String method) {
    state = state.copyWith(paymentMethod: method);
  }

  void reset() {
    state = const BookingState();
  }
}

/// Provider global
final bookingProvider =
    NotifierProvider<BookingNotifier, BookingState>(BookingNotifier.new);
