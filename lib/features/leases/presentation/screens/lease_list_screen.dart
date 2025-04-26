import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rent_me/core/constants/constants.dart';
import 'package:rent_me/features/leases/data/models/lease.dart';
import 'package:rent_me/features/leases/presentation/providers/lease_provider.dart';
import 'package:rent_me/features/leases/presentation/widgets/lease_item_card.dart';
import 'package:rent_me/shared/widgets/extensions_methods.dart';

class LeaseListScreen extends ConsumerWidget {
  const LeaseListScreen({super.key});

  Map<String, List<Lease>> _groupLeasesByStatus(List<Lease> leases) {
    final grouped = <String, List<Lease>>{};

    const statusOrder = ['AC', 'PE', 'CO', 'CA', 'RE'];

    for (var status in statusOrder) {
      grouped[status] = [];
    }

    for (final lease in leases) {
      if (grouped.containsKey(lease.status)) {
        grouped[lease.status]!.add(lease);
      } else {
        grouped.putIfAbsent('Other', () => []).add(lease);
      }
    }
    grouped.removeWhere((key, value) => value.isEmpty);
    return grouped;
  }

  String _getStatusCategoryTitle(String statusKey) {
    switch (statusKey) {
      case 'AC':
        return 'Active Leases';
      case 'PE':
        return 'Pending Requests';
      case 'CO':
        return 'Completed Leases';
      case 'CA':
        return 'Cancelled Leases';
      case 'RE':
        return 'Rejected Requests';
      default:
        return 'Other';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leasesAsyncValue = ref.watch(myLeasesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Leases')),
      body: leasesAsyncValue.when(
        skipLoadingOnRefresh: true,
        loading:
            () => const Center(child: CircularProgressIndicator.adaptive()),
        error:
            (error, stackTrace) => Center(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error loading leases: $error'),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => ref.refresh(myLeasesProvider),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
        data: (leases) {
          if (leases.isEmpty) {
            return const Center(child: Text('You have no leases yet.'));
          }

          final groupedLeases = _groupLeasesByStatus(leases);

          final orderedKeys = groupedLeases.keys.toList();

          return RefreshIndicator.adaptive(
            onRefresh: () => ref.refresh(myLeasesProvider.future),
            child: ListView.builder(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              itemCount: orderedKeys.length,
              itemBuilder: (context, index) {
                final statusKey = orderedKeys[index];
                final categoryLeases = groupedLeases[statusKey]!;
                final categoryTitle = _getStatusCategoryTitle(statusKey);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          categoryTitle,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: categoryLeases.length,
                        itemBuilder: (context, leaseIndex) {
                          final lease = categoryLeases[leaseIndex];
                          return LeaseItemCard(
                            lease: lease,
                            onTap: () {
                              context.go(
                                AppConstants.leaseDetailRoute.swapId(
                                  id: lease.id.toString(),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
