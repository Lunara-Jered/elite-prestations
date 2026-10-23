import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/services/supabase_service.dart';
import '../shared/models/service_model.dart';

export '../shared/models/service_model.dart';

final servicesProvider =
    AsyncNotifierProvider<ServicesNotifier, List<ServiceModel>>(
  ServicesNotifier.new,
);

class ServicesNotifier extends AsyncNotifier<List<ServiceModel>> {
  @override
  Future<List<ServiceModel>> build() => _fetchServices();

  Future<List<ServiceModel>> _fetchServices() async {
    try {
      final data = await SupabaseService.client
          .from('services')
          .select()
          .order('name');
      return data
          .map(
            (json) => ServiceModel.fromJson(Map<String, dynamic>.from(json)),
          )
          .toList();
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<void> addService(ServiceModel service) async {
    try {
      await SupabaseService.client
          .from('services')
          .insert(service.toSupabaseJson());
      state = await AsyncValue.guard(_fetchServices);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<void> updateService(ServiceModel service) async {
    try {
      await SupabaseService.client
          .from('services')
          .update(service.toSupabaseJson())
          .eq('id', service.id);
      state = await AsyncValue.guard(_fetchServices);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<void> deleteService(String id) async {
    try {
      await SupabaseService.client.from('services').delete().eq('id', id);
      state = await AsyncValue.guard(_fetchServices);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }
}
