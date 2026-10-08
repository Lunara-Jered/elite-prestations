// TODO: Define shared corner radii.
import 'package:flutter/widgets.dart';

/// Rayons de bordure cohérents
class AppRadius {
  AppRadius._();
  
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double pill = 999.0;
  
  static const BorderRadius cardRadius = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius buttonRadius = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius modalRadius = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius pillRadius = BorderRadius.all(Radius.circular(pill));
}