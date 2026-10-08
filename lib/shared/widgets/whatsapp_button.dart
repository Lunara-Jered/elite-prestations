// TODO: Implement the WhatsApp button.
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';

class WhatsAppButton extends StatelessWidget {
  const WhatsAppButton({super.key});

  Future<void> _openWhatsApp() async {
    final uri = Uri.parse(AppStrings.whatsappLink);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: _openWhatsApp,
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
      shape: const CircleBorder(),
      child: const Icon(Icons.chat_bubble_outline),
    );
  }
}
