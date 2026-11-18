class AppProfile {
  const AppProfile({
    required this.id,
    this.fullName = '',
    this.email,
    this.phone,
    this.avatarUrl,
    this.role = 'customer',
    this.notificationsEnabled = true,
    this.orderNotifications = true,
    this.soundNotifications = true,
    this.promoNotifications = false,
  });

  final String id;
  final String fullName;
  final String? email;
  final String? phone;
  final String? avatarUrl;
  final String role;
  final bool notificationsEnabled;
  final bool orderNotifications;
  final bool soundNotifications;
  final bool promoNotifications;

  bool get isMitra => role == 'mitra';

  factory AppProfile.fromMap(Map<String, dynamic> map) {
    return AppProfile(
      id: map['id'] as String,
      fullName: map['full_name'] as String? ?? '',
      email: map['email'] as String?,
      phone: map['phone'] as String?,
      avatarUrl: map['avatar_url'] as String?,
      role: map['role'] as String? ?? 'customer',
      notificationsEnabled: map['notifications_enabled'] as bool? ?? true,
      orderNotifications: map['order_notifications'] as bool? ?? true,
      soundNotifications: map['sound_notifications'] as bool? ?? true,
      promoNotifications: map['promo_notifications'] as bool? ?? false,
    );
  }
}
