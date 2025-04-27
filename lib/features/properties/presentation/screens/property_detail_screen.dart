import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rent_me/core/constants/app_constants.dart';
import 'package:rent_me/features/auth/data/auth_repository.dart';
import 'package:rent_me/features/properties/data/models/property.dart';
import 'package:rent_me/features/properties/presentation/providers/property_provider.dart';
import 'package:rent_me/shared/enums.dart';
import 'package:rent_me/shared/providers/is_landlord.dart';
import 'package:rent_me/shared/widgets/extensions_methods.dart';
import 'package:rent_me/shared/widgets/protected_btn.dart';
import 'package:url_launcher/url_launcher.dart';

class PropertyDetailScreen extends ConsumerStatefulWidget {
  final String propertyId;
  const PropertyDetailScreen({super.key, required this.propertyId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends ConsumerState<PropertyDetailScreen> {
  Color _getColor(AvailabilityStatus status, BuildContext context) {
    switch (status) {
      case AvailabilityStatus.rented:
        return Colors.red;
      case AvailabilityStatus.available:
        return Colors.green;
      case AvailabilityStatus.pending:
        return Colors.yellow;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final propertyAsync = ref.watch(propertyDetailProvider(widget.propertyId));
    final isLandlord = ref.watch(isLandLordProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Property Detail')),
      body: propertyAsync.when(
        skipLoadingOnRefresh: true,
        loading:
            () => const Center(child: CircularProgressIndicator.adaptive()),
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
        data: (property) => _buildPropertyDetail(context, property, isLandlord),
      ),
    );
  }

  Widget _buildPropertyDetail(
    BuildContext context,
    Property property,
    bool isLandLord,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 300,
            child: CarouselView(
              itemExtent: 400,
              scrollDirection: Axis.horizontal,
              itemSnapping: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  AppConstants.defaultBorderRadius / 2,
                ),
              ),
              children:
                  property.images
                      .map(
                        (e) => CachedNetworkImage(
                          imageUrl: e!.imgUrl,
                          fit: BoxFit.cover,
                          errorWidget:
                              (context, url, error) => Icon(
                                Icons.broken_image,
                                color: Theme.of(context).primaryColor,
                              ),
                        ),
                      )
                      .toList(),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            property.title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            property.township.toString(),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'MMK ${property.pricePerMonth} / month',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(property.description),
          const Divider(height: 32),
          _buildInfoRow('Bedrooms', '${property.bedrooms}'),
          _buildInfoRow('Bathrooms', property.bathrooms),
          _buildInfoRow('Furnished', property.isFurnished ? 'Yes' : 'No'),
          _buildInfoRow('Pet Policy', property.petPolicy),
          _buildInfoRow('Parking', property.parkingType),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Availability',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    property.availabilityStatus.displayName.capitalize(),
                    style: TextStyle(
                      color: _getColor(property.availabilityStatus, context),
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildInfoRow('Property Type', property.propertyType.name),
          _buildInfoRow(
            'Owner Verified',
            property.ownerIsVerified ? 'Yes' : 'No',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Owner Phone',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: GestureDetector(
                    onTap: () async {
                      final phone = property.ownerPhone;
                      await launchUrl(Uri(scheme: 'tel', path: phone));
                    },
                    child: Text(
                      property.ownerPhone.capitalize(),
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text('Amenities', style: Theme.of(context).textTheme.titleMedium),
          Wrap(
            spacing: 8,
            children:
                property.amenities
                    .map((e) => Chip(label: Text(e.name)))
                    .toList(),
          ),
          const SizedBox(height: 20),
          if (!isLandLord &&
              property.availabilityStatus == AvailabilityStatus.available)
            ProtectedButton(
              onPressed: () {
                final location = AppConstants.propertyOfferRoute.swapId(
                  id: property.id.toString(),
                );
                context.go(location);
              },
              child: const Text('Offer'),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(flex: 3, child: Text(value.capitalize())),
        ],
      ),
    );
  }
}
