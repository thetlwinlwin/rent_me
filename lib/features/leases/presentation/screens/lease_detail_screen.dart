import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rent_me/core/constants/app_constants.dart';
import 'package:rent_me/features/leases/presentation/providers/lease_provider.dart';
import 'package:rent_me/shared/providers/is_landlord.dart';
import 'package:url_launcher/url_launcher.dart';

class LeaseDetailScreen extends ConsumerWidget {
  final String id;

  const LeaseDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(leaseDetailProvider(id));
    final isLandLord = ref.watch(isLandLordProvider);

    return data.when(
      skipLoadingOnRefresh: true,
      data:
          (lease) => Scaffold(
            appBar: AppBar(title: const Text('Lease Detail')),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  Text(
                    lease.propertyDetails?.title ?? 'No title',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(lease.propertyDetails?.address ?? 'No address'),
                  const SizedBox(height: 16),
                  ListTile(
                    title: const Text('Tenant'),
                    subtitle: Text(
                      '${lease.tenantDetails?.firstName ?? ''} ${lease.tenantDetails?.lastName ?? ''}',
                    ),
                    trailing:
                        lease.tenantDetails?.profile?.phoneNumber != null
                            ? IconButton.outlined(
                              onPressed: () async {
                                final phone =
                                    lease.tenantDetails?.profile?.phoneNumber;
                                await launchUrl(
                                  Uri(scheme: 'tel', path: phone),
                                );
                              },
                              icon: Icon(Icons.call),
                            )
                            : null,
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('Lease Start'),
                    subtitle: Text(
                      lease.startDate.toLocal().toString().split(' ')[0],
                    ),
                  ),
                  ListTile(
                    title: const Text('Lease End'),
                    subtitle: Text(
                      lease.endDate.toLocal().toString().split(' ')[0],
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('Status'),
                    subtitle: Text(lease.statusDisplay),
                  ),
                  ListTile(
                    title: const Text('Monthly Rent'),
                    subtitle: Text(
                      'MMK ${lease.monthlyRentAtSigning.toStringAsFixed(0)}',
                    ),
                  ),
                  ListTile(
                    title: const Text('Deposit Paid'),
                    subtitle: Text(
                      'MMK ${lease.depositPaidAmount.toStringAsFixed(0)}',
                    ),
                  ),
                  if (lease.depositPaidDate != null)
                    ListTile(
                      title: const Text('Deposit Paid Date'),
                      subtitle: Text(
                        lease.depositPaidDate!.toLocal().toString().split(
                          ' ',
                        )[0],
                      ),
                    ),
                  if (lease.status == 'PE' && isLandLord)
                    ElevatedButton(
                      onPressed: () {
                        ref
                            .read(leaseDetailProvider(id).notifier)
                            .approveLease();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Accept'),
                    ),
                  const SizedBox(height: 15),
                  if (lease.status == 'PE' && isLandLord)
                    ElevatedButton(
                      onPressed: () {
                        ref
                            .read(leaseDetailProvider(id).notifier)
                            .rejectLease();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Reject'),
                    ),
                ],
              ),
            ),
          ),
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
      error:
          (error, stackTrace) => Center(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('Error loading leases: $error')],
              ),
            ),
          ),
    );
  }
}
