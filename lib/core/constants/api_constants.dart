// lib/core/constants/api_constants.dart
abstract class APIConstants {
  static const String baseUrl = 'http://192.168.100.180:8000/api/v1';

  // Auth Endpoints
  static const String login = '/auth/login/';
  static const String logout = '/auth/logout/';

  // Lease Endpoints
  static const String leases = '/leases/';
  static const String leaseDetail = '/leases/{id}/';
  static const String leaseApprove = '/leases/{id}/approve/';
  static const String leaseReject = '/leases/{id}/reject/';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 20);

  // Headers
  static const String authHeader = 'Authorization';

  // properties/types/amenities
  static const String properties = '/properties/';
  static const String propertyDetail = '/properties/{id}/';
  static const String propertyTypes = '/property-types/';
  static const String amenities = '/amenities/';
  static const String townships = '/townships/';
  // Nested property images - base path might be useful, or construct fully in repo
  static const String propertyImagesBase = '/properties/{id}/images/';

  // leases/reviews
  static const String leaseReviewsBase = '/leases/{id}/reviews/';

  // users/profile
  static const String currentUser = '/users/me/';
  static const String currentUserProfile = '/users/me/profile/';

  // registration (if using dj-rest-auth)
  static const String registration = '/auth/registration/';
  static const String verifyEmail = '/auth/registration/verify-email/';
}
