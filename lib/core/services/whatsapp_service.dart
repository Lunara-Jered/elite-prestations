import 'package:whatsapp_launcher/whatsapp_launcher.dart';

class WhatsAppService {
  WhatsAppService._();

  static Future<void> sendReservationNotification(
    String phoneNumber,
    String reservationDetails,
  ) async {
    final phone = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
    if (phone.isEmpty) {
      throw ArgumentError.value(phoneNumber, 'phoneNumber', 'Numéro invalide.');
    }

    final launched = await WhatsAppLauncher.launchWhatsAppMessage(
      phoneNumber: phone,
      message: 'Nouvelle réservation Élite Prestations : $reservationDetails',
    );
    if (!launched) {
      throw StateError('WhatsApp n’a pas pu être ouvert.');
    }
  }
}
