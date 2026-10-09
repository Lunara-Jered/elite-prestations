// ─────────────────────────────────────────
// FORMATAGE FCFA
// ─────────────────────────────────────────

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

/// Formate un montant sans le suffixe (pour PDF)
/// Exemple : 250000 → "250 000"
String formatNumber(int amount) {
  final str = amount.toString();
  final buffer = StringBuffer();
  for (int i = 0; i < str.length; i++) {
    if (i > 0 && (str.length - i) % 3 == 0) buffer.write(' ');
    buffer.write(str[i]);
  }
  return buffer.toString();
}

// ─────────────────────────────────────────
// CALCULS TPS (GABON)
// ─────────────────────────────────────────

/// Taux TPS au Gabon (9,5%)
const double tpsRate = 0.095;

/// Calculs HT / TPS / TTC / Acompte
class PriceBreakdown {
  final int subtotalHT;
  final int tps;
  final int totalTTC;
  final int deposit;

  const PriceBreakdown({
    required this.subtotalHT,
    required this.tps,
    required this.totalTTC,
    required this.deposit,
  });

  factory PriceBreakdown.fromSubtotal(int subtotal) {
    final tps = (subtotal * tpsRate).round();
    final totalTTC = subtotal + tps;
    final deposit = (totalTTC * 0.5).round();

    return PriceBreakdown(
      subtotalHT: subtotal,
      tps: tps,
      totalTTC: totalTTC,
      deposit: deposit,
    );
  }
}
