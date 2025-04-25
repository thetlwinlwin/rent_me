enum LeaseStatus {
  pending('PE', 'Pending Approval'),
  active('AC', 'Active'),
  completed('CO', 'Completed'),
  cancelled('CA', 'Cancelled'),
  rejected('RE', 'Rejected'),
  unknown('', 'Unknown');

  final String apiKey;
  final String displayName;
  const LeaseStatus(this.apiKey, this.displayName);

  static LeaseStatus fromApiKey(String key) {
    return LeaseStatus.values.firstWhere(
      (status) => status.apiKey == key,
      orElse: () => LeaseStatus.unknown,
    );
  }
}

enum UserRole {
  tenant('TE', 'Tenant'),
  landlord('LA', 'Landlord');

  final String apiKey;
  final String displayName;
  const UserRole(this.apiKey, this.displayName);

  static UserRole fromApiKey(String key) {
    return UserRole.values.firstWhere(
      (e) => e.apiKey == key,
      orElse: () => UserRole.tenant,
    );
  }

  static String toApiKey(UserRole role) => role.apiKey;
}

enum AvailabilityStatus {
  available('AV', 'Available'),
  rented('RE', 'Rented'),
  pending('PE', 'Pending Lease'),
  unavailable('UN', 'Unavailable');

  final String apiKey;
  final String displayName;
  const AvailabilityStatus(this.apiKey, this.displayName);

  static AvailabilityStatus fromApiKey(String key) {
    return AvailabilityStatus.values.firstWhere(
      (status) => status.apiKey == key,
      orElse: () => AvailabilityStatus.unavailable,
    );
  }

  static String toApiKey(AvailabilityStatus status) => status.apiKey;
}
