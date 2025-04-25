import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rent_me/features/auth/presentation/providers/auth_provider.dart';
import 'package:rent_me/features/leases/data/lease_repository.dart';
import 'package:rent_me/features/leases/data/models/lease.dart';

final myLeasesProvider = FutureProvider.autoDispose<List<Lease>>((ref) async {
  final leaseRepository = ref.watch(leaseRepositoryProvider);
  ref.watch(authNotifierProvider);
  return await leaseRepository.fetchMyLeases();
});

final leaseDetailProvider =
    AsyncNotifierProviderFamily<LeaseDetailNotifier, Lease, String>(
      LeaseDetailNotifier.new,
    );

final leaseOfferProvider = FutureProvider.family
    .autoDispose<Lease, CreateLease>((ref, arg) async {
      final leaseRepository = ref.watch(leaseRepositoryProvider);
      ref.invalidate(myLeasesProvider);
      return await leaseRepository.leaseOffer(arg);
    });

class LeaseDetailNotifier extends FamilyAsyncNotifier<Lease, String> {
  @override
  Future<Lease> build(String arg) {
    return _fetchLeaseDetails(arg);
  }

  Future<Lease> _fetchLeaseDetails(String arg) async {
    final repo = ref.read(leaseRepositoryProvider);
    return await repo.fetchLeaseDetail(arg);
  }

  Future<void> approveLease() async {
    state = AsyncLoading();
    final repo = ref.read(leaseRepositoryProvider);
    state = await AsyncValue.guard(() async => await repo.approveLease(arg));
    ref.invalidate(myLeasesProvider);
  }

  Future<void> rejectLease() async {
    state = AsyncLoading();
    final repo = ref.read(leaseRepositoryProvider);
    state = await AsyncValue.guard(() async => await repo.rejectLease(arg));
    ref.invalidate(myLeasesProvider);
  }
}
