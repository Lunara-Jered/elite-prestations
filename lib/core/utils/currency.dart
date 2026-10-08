// TODO: Add currency formatting helpers.
import 'package:intl/intl.dart';

/// Taux de TVA au Gabon
const double tvaRate = 0.18;

/// Formate un montant en FCFA
/// Exemple : 250000 → "250 000 FCFA"
String formatFCFA(int amount) {
  final formatter = NumberFormat('#,###', 'fr_FR');
  return '${formatter.format(amount).replaceAll(',', ' ')} FCFA';
}

/// Calculs HT / TVA / TTC / Acompte
class PriceBreakdown {
  final int subtotalHT;
  final int tva;
  final int totalTTC;
  final int deposit;

  const PriceBreakdown({
    required this.subtotalHT,
    required this.tva,
    required this.totalTTC,
    required this.deposit,
  });

  factory PriceBreakdown.fromSubtotal(int subtotalHT) {
    final tva = (subtotalHT * tvaRate).round();
    final totalTTC = subtotalHT + tva;
    final deposit = (totalTTC * 0.5).round();

    return PriceBreakdown(
      subtotalHT: subtotalHT,
      tva: tva,
      totalTTC: totalTTC,
      deposit: deposit,
    );
  }
}
