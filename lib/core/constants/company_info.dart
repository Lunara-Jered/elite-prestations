/// Informations officielles Élite Prestations
class CompanyInfo {
  CompanyInfo._();

  // ─────────────────────────────────────────
  // IDENTITÉ
  // ─────────────────────────────────────────
  static const String name = 'ELITE PRESTATIONS';
  static const String slogan = 'Le Meilleur Pour Vous';
  static const String tagline = 'Prestations multiservices & Location de matériels';

  // ─────────────────────────────────────────
  // COORDONNÉES
  // ─────────────────────────────────────────
  static const String address = 'Libreville, Gabon';
  static const String nif = '299086A';
  static const String rccm = 'RG LBV2018A4570';

  static const String phone1 = '+241 62 39 11 21';
  static const String phone2 = '+241 77 02 30 04';
  static const String email = 'eliteprestationpourvous@gmail.com';

  // ─────────────────────────────────────────
  // TAXE (TPS Gabon)
  // ─────────────────────────────────────────
  /// TPS = Taxe sur les Prestations de Services (Gabon)
  static const double tpsRate = 0.095; // 9,5%

  /// Durée de validité des devis (jours)
  static const int devisValidityDays = 30;

  // ─────────────────────────────────────────
  // COULEURS PDF (pour le rendu)
  // ─────────────────────────────────────────
  static const int pdfPrimaryR = 30;
  static const int pdfPrimaryG = 58;
  static const int pdfPrimaryB = 138;

  static const int pdfDevisR = 139;
  static const int pdfDevisG = 92;
  static const int pdfDevisB = 246;
}
