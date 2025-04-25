class PropertyFilter {
  final String? minPrice;
  final String? maxPrice;
  final String? township;
  final int? bedrooms;
  final String? propertyType;
  final bool isFurnished;
  final bool acsendingPrice;

  PropertyFilter({
    required this.minPrice,
    required this.maxPrice,
    required this.township,
    required this.bedrooms,
    required this.propertyType,
    this.acsendingPrice = true,
    this.isFurnished = false,
  });

  Map<String, dynamic> toQueryParams() {
    final params = <String, dynamic>{};

    if (township != null && township!.isNotEmpty) {
      params['township'] = township;
    }
    if (propertyType != null && propertyType!.isNotEmpty) {
      params['property_type'] = propertyType;
    }
    if (bedrooms != null) {
      params['bedrooms'] = bedrooms;
    }
    if (minPrice != null) {
      params['min_price'] = minPrice;
    }

    if (maxPrice != null) {
      params['max_price'] = maxPrice;
    }
    params['is_furnished'] = isFurnished;
    params['ordering'] =
        acsendingPrice ? 'price_per_month' : '-price_per_month';

    return params;
  }
}
