import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/services/local_storage_service.dart';
import '../shared/models/message_model.dart';
import 'auth_provider.dart';

final messagesProvider =
    NotifierProvider<MessagesNotifier, List<MessageModel>>(
  MessagesNotifier.new,
);

class MessagesNotifier extends Notifier<List<MessageModel>> {
  late LocalStorageService _storage;
  late String _storageKey;
  bool _isSending = false;

  @override
  List<MessageModel> build() {
    _storage = ref.read(localStorageServiceProvider);
    final userId = ref.watch(authProvider.select((state) => state.user?.id));
    _storageKey = 'messages_${userId ?? 'guest'}';
    return List.unmodifiable(
      _storage.readList(_storageKey, MessageModel.fromJson)
        ..sort((a, b) => a.sentAt.compareTo(b.sentAt)),
    );
  }

  Future<void> sendMessage(String text) async {
    final content = text.trim();
    if (content.isEmpty) throw ArgumentError('Le message ne peut pas être vide.');
    if (_isSending) return;
    _isSending = true;
    try {
      final userMessage = MessageModel(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        text: content,
        isFromAdmin: false,
        sentAt: DateTime.now(),
      );
      await _append(userMessage);
      await Future<void>.delayed(const Duration(seconds: 1));
      final reply = MessageModel(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        text: 'Merci pour votre message. Un conseiller Élite Prestations vous répondra dès que possible.',
        isFromAdmin: true,
        sentAt: DateTime.now(),
      );
      await _append(reply);
    } finally {
      _isSending = false;
    }
  }

  Future<void> _append(MessageModel message) async {
    final updated = [...state, message];
    await _storage.saveList(
      _storageKey,
      updated,
      (item) => item.toJson(),
    );
    state = List.unmodifiable(updated);
  }
}
