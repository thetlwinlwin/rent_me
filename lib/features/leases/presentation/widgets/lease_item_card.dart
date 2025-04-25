import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:rent_me/core/constants/constants.dart';
import 'package:rent_me/features/leases/data/models/lease.dart';
import 'package:rent_me/shared/providers/is_landlord.dart';

class LeaseItemCard extends ConsumerWidget {
  final Lease lease;
  final VoidCallback onTap;

  const LeaseItemCard({super.key, required this.lease, required this.onTap});

  Color _getStatusColor(String statusKey) {
    switch (statusKey) {
      case 'AC':
        return Colors.green.shade700;
      case 'PE':
        return Colors.orange.shade700;
      case 'CO':
        return Colors.blueGrey;
      case 'CA':
      case 'RE':
        return Colors.red.shade700;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFormat = DateFormat(AppConstants.defaultDateFormat);
    final statusColor = _getStatusColor(lease.status);
    final isLandLord = ref.watch(isLandLordProvider);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          AppConstants.defaultBorderRadius / 2,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          AppConstants.defaultBorderRadius / 2,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding * 0.75),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lease.propertyDetails?.title ??
                          'Property Title Unavailable',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${dateFormat.format(lease.startDate)} - ${dateFormat.format(lease.endDate)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 6),
                    if (isLandLord)
                      Text(
                        'Tenant: ${lease.tenantDetails?.username ?? 'N/A'}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Chip(
                label: Text(
                  lease.statusDisplay,
                  style: Theme.of(
                    context,
                  ).textTheme.labelSmall?.copyWith(color: Colors.white),
                ),
                backgroundColor: statusColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 2.0,
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                labelPadding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
