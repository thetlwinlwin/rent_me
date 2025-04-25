// lib/core/constants/app_constants.dart
abstract class AppConstants {
  // Storage Keys
  static const String authTokenKey = 'auth_token';
  static const String userIdKey = 'user_id';
  static const String emailStatus = 'email_status';
  static const String themeModeKey = 'theme_mode';
  static const String lastOfferDate = 'last_offer_date';

  // Default Values
  static const String defaultDateFormat = 'MMM dd, yyyy';

  // UI Routes
  static const String propertiesRoute = '/properties';
  static const String propertyAddRoute = '/properties/add';
  static const String propertyDetailsRoute = '/properties/{id}';
  static const String propertyOfferRoute = '/properties/{id}/offer';
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String profileRoute = '/profile';
  static const String profileEditRoute = '/profile/edit';
  static const String homeRoute = '/';
  static const String splashRoute = '/splash';
  static const String verifyRoute = '/verify';
  static const String leasesRoute = '/leases';
  static const String leaseDetailRoute = '/leases/{id}';

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 12.0;
}
