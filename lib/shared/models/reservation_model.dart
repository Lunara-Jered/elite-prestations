import '../../features/booking/providers/booking_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum ReservationStatus {
  pending,
  confirmed,
  inProgress,
  completed,
  cancelled,
}

class ReservationModel {
  final String id;
  final String reference;
  final String serviceName;
  final DateTime startDate;
  final DateTime endDate;
  final int duration;
  final int totalTTC;
  final int deposit;
  final ReservationStatus status;
  final List<BookingOption> options;
  final DateTime createdAt;
  final String? clientId;
  final String? clientName;
  final String? clientEmail;

  const ReservationModel({
    required this.id,
    required this.reference,
    required this.serviceName,
    required this.startDate,
    required this.endDate,
    required this.duration,
    required this.totalTTC,
    required this.deposit,
    required this.status,
    this.options = const [],
    required this.createdAt,
    this.clientId,
    this.clientName,
    this.clientEmail,
  });

  ReservationModel copyWith({ReservationStatus? status}) => ReservationModel(
        id: id,
        reference: reference,
        serviceName: serviceName,
        startDate: startDate,
        endDate: endDate,
        duration: duration,
        totalTTC: totalTTC,
        deposit: deposit,
        status: status ?? this.status,
        options: options,
        createdAt: createdAt,
        clientId: clientId,
        clientName: clientName,
        clientEmail: clientEmail,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'reference': reference,
        'serviceName': serviceName,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'duration': duration,
        'totalTTC': totalTTC,
        'deposit': deposit,
        'status': status.name,
        'options': options.map((option) => option.toJson()).toList(),
        'createdAt': createdAt.toIso8601String(),
        'clientId': clientId,
        'clientName': clientName,
        'clientEmail': clientEmail,
      };

  Map<String, dynamic> toSupabaseJson({String? userId}) => {
        'user_id': userId ?? Supabase.instance.client.auth.currentUser?.id,
        'service_name': serviceName,
        'start_date': startDate.toIso8601String().split('T')[0], // Format YYYY-MM-DD pour le type 'date'
        'duration': duration,
        'total_ttc': totalTTC,
        'status': status.name,
      };

  factory ReservationModel.fromJson(Map<String, dynamic> json) =>
      ReservationModel(
        id: '${json['id']}',
        reference: json['reference'] as String,
        serviceName: (json['service_name'] ?? json['serviceName']) as String,
        startDate:
            DateTime.parse((json['start_date'] ?? json['startDate']) as String),
        endDate:
            DateTime.parse((json['end_date'] ?? json['endDate']) as String),
        duration: (json['duration'] as num).toInt(),
        totalTTC: ((json['total_ttc'] ?? json['totalTTC']) as num).toInt(),
        deposit: (json['deposit'] as num).toInt(),
        status: ReservationStatus.values.byName(json['status'] as String),
        options: (json['options'] as List<dynamic>? ?? [])
            .map((item) =>
                BookingOption.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList(),
        createdAt:
            DateTime.parse((json['created_at'] ?? json['createdAt']) as String),
        clientId: (json['user_id'] ?? json['clientId']) as String?,
        clientName: (json['client_name'] ?? json['clientName']) as String?,
        clientEmail: (json['client_email'] ?? json['clientEmail']) as String?,
      );
}
