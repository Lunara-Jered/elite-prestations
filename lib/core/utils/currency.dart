// TODO: Add currency formatting helpers.

/// Taux de TVA au Gabon
const double tvaRate = 0.18;

/// Formate un montant en FCFA
/// Exemple : 250000 → "250 000 FCFA"
String formatFCFA(int amount) {
  final str = amount.toString();
  final buffer = StringBuffer();
  for (int i = 0; i < str.length; i++) {
    if (i > 0 && (str.length - i) % 3 == 0) buffer.write(' ');
    buffer.write(str[i]);
  }
  return '$buffer FCFA';
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

  factory PriceBreakdown.fromSubtotal(int subtotal) {
    final tva = (subtotal * tvaRate).round();
    final totalTTC = subtotal + tva;
    final deposit = (totalTTC * 0.5).round();

    return PriceBreakdown(
      subtotalHT: subtotal,
      tva: tva,
      totalTTC: totalTTC,
      deposit: deposit,
    );
  }
}
