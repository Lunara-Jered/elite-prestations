class MessageModel {
  final String id;
  final String text;
  final bool isFromAdmin;
  final DateTime sentAt;

  const MessageModel({
    required this.id,
    required this.text,
    required this.isFromAdmin,
    required this.sentAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'isFromAdmin': isFromAdmin,
        'sentAt': sentAt.toIso8601String(),
      };

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        id: json['id'] as String,
        text: json['text'] as String,
        isFromAdmin: json['isFromAdmin'] as bool,
        sentAt: DateTime.parse(json['sentAt'] as String),
      );
}
