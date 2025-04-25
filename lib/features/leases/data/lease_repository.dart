// lib/features/leases/data/repositories/lease_repository.dart

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rent_me/core/constants/constants.dart';
import 'package:rent_me/core/network/dio_client.dart';
import 'package:rent_me/features/leases/data/models/lease.dart';

class LeaseRepository {
  final Dio _dio;

  LeaseRepository(this._dio);

  Future<List<Lease>> fetchMyLeases() async {
    try {
      final response = await _dio.get(APIConstants.leases);

      if (response.statusCode == 200) {
        final data = response.data as List;
        return data
            .map((item) => Lease.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
          'Failed to fetch leases: Status code ${response.statusCode}',
        );
      }
    } on DioException {
      throw Exception('Network error fetching leases. Please try again.');
    } catch (e) {
      print(e);
      throw Exception('An unexpected error occurred while fetching leases.');
    }
  }

  Future<Lease> fetchLeaseDetail(String leaseId) async {
    try {
      final response = await _dio.get(
        APIConstants.leaseDetail.replaceAll('{id}', leaseId),
      );

      if (response.statusCode == 200) {
        return Lease.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception(
          'Failed to fetch lease detail: Status code ${response.statusCode}',
        );
      }
    } on DioException {
      throw Exception('Network error fetching lease detail. Please try again.');
    } catch (e) {
      throw Exception(
        'An unexpected error occurred while fetching lease detail.',
      );
    }
  }

  // --- TODO: Add other methods as needed ---
  Future<Lease> leaseOffer(CreateLease leaseDetails) async {
    try {
      final response = await _dio.post(
        APIConstants.leases,
        data: leaseDetails.toJson(),
      );

      if (response.statusCode == 201) {
        return Lease.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception(
          'Failed to fetch lease detail: Status code ${response.statusCode}',
        );
      }
    } on DioException {
      throw Exception('Network error fetching lease detail. Please try again.');
    } catch (e) {
      throw Exception(
        'An unexpected error occurred while fetching lease detail.',
      );
    }
  }

  Future<Lease> approveLease(String leaseId) async {
    try {
      final response = await _dio.post(
        APIConstants.leaseApprove.replaceAll('{id}', leaseId),
      );

      if (response.statusCode == 200) {
        return Lease.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception(
          'Failed to fetch lease detail: Status code ${response.statusCode}',
        );
      }
    } on DioException {
      throw Exception('Network error fetching lease detail. Please try again.');
    } catch (e) {
      throw Exception(
        'An unexpected error occurred while fetching lease detail.',
      );
    }
  }

  Future<Lease> rejectLease(String leaseId) async {
    try {
      final response = await _dio.post(
        APIConstants.leaseReject.replaceAll('{id}', leaseId),
      );

      if (response.statusCode == 200) {
        return Lease.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception(
          'Failed to fetch lease detail: Status code ${response.statusCode}',
        );
      }
    } on DioException {
      throw Exception('Network error fetching lease detail. Please try again.');
    } catch (e) {
      throw Exception(
        'An unexpected error occurred while fetching lease detail.',
      );
    }
  }
}

final leaseRepositoryProvider = Provider.autoDispose<LeaseRepository>((ref) {
  final dio = ref.watch(dioClientProvider);
  return LeaseRepository(dio);
});
