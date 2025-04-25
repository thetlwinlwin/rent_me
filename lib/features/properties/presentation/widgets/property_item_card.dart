import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rent_me/core/constants/constants.dart';
import 'package:rent_me/features/properties/data/models/property.dart';

class PropertyItemCard extends ConsumerWidget {
  final Property property;
  final VoidCallback onTap;

  const PropertyItemCard({
    super.key,
    required this.property,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          AppConstants.defaultBorderRadius / 2,
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 240,
            child:
                property.images.isNotEmpty
                    ? CarouselView(
                      itemExtent: 400,
                      onTap: (_) => onTap(),
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
                    )
                    : Center(child: Icon(Icons.no_photography)),
          ),
          ListTile(
            onTap: onTap,
            title: Text(
              property.title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              property.township.toString(),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            trailing: Text(
              'MMK ${property.pricePerMonth.split('.').first}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
