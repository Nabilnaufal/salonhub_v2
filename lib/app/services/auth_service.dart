import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/app_profile.dart';

/// Satu-satunya pintu untuk autentikasi Supabase.
class AuthService extends GetxService {
  SupabaseClient get _client => Supabase.instance.client;

  User? get user => _client.auth.currentUser;
  bool get isLoggedIn => user != null;

  final profile = Rxn<AppProfile>();
  final isBusy = false.obs;

  @override
  void onInit() {
    super.onInit();
    _client.auth.onAuthStateChange.listen((state) {
      if (state.session == null) {
        profile.value = null;
      } else {
        loadProfile();
      }
    });

    if (isLoggedIn) {
      loadProfile();
    }
  }

  Future<AppProfile?> loadProfile() async {
    final currentUser = user;
    if (currentUser == null) {
      profile.value = null;
      return null;
    }

    final row = await _client
        .from('profiles')
        .select()
        .eq('id', currentUser.id)
        .maybeSingle();

    profile.value = row == null ? null : AppProfile.fromMap(row);
    return profile.value;
  }

  Future<void> signIn({required String email, required String password}) async {
    await _client.auth.signInWithPassword(email: email, password: password);
    await loadProfile();
  }

  Future<void> signUpCustomer({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    await _client.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': name, 'phone': phone, 'role': 'customer'},
    );
    await loadProfile();
  }

  Future<void> signUpMitra({
    required String shopName,
    required String ownerName,
    required String email,
    required String phone,
    required String address,
    required String password,
  }) async {
    await _client.auth.signUp(
      email: email,
      password: password,
      data: {
        'full_name': ownerName,
        'phone': phone,
        'role': 'mitra',
        'shop_name': shopName,
        'address': address,
      },
    );
    await loadProfile();
  }

  /// Membuat/mengklaim toko milik mitra yang sedang login.
  Future<Map<String, dynamic>?> ensureShop() async {
    if (!isLoggedIn) return null;
    final row = await _client.rpc('register_shop');
    return (row as Map).cast<String, dynamic>();
  }

  Future<void> resetPassword(String email) {
    return _client.auth.resetPasswordForEmail(email);
  }

  Future<void> verifySignupOtp({
    required String email,
    required String token,
  }) async {
    final response = await _client.auth.verifyOTP(
      email: email,
      token: token,
      type: OtpType.signup,
    );
    if (response.session != null) {
      await loadProfile();
    }
  }

  Future<void> resendSignupOtp(String email) async {
    await _client.auth.resend(email: email, type: OtpType.signup);
  }

  Future<void> updateProfile({
    String? fullName,
    String? phone,
    String? avatarUrl,
  }) async {
    final currentUser = user;
    if (currentUser == null) return;

    await _client
        .from('profiles')
        .update({
          'full_name': ?fullName,
          'phone': ?phone,
          'avatar_url': ?avatarUrl,
        })
        .eq('id', currentUser.id);
    await loadProfile();
  }

  Future<void> changePassword(String newPassword) async {
    await _client.auth.updateUser(UserAttributes(password: newPassword));
  }

  Future<String> uploadPhoto(
    Uint8List bytes, {
    String folder = 'uploads',
    String extension = 'jpg',
  }) async {
    final path =
        '$folder/${user?.id ?? 'anon'}/${DateTime.now().millisecondsSinceEpoch}.$extension';
    await _client.storage
        .from('photos')
        .uploadBinary(
          path,
          bytes,
          fileOptions: FileOptions(
            contentType: 'image/$extension',
            upsert: true,
          ),
        );
    return _client.storage.from('photos').getPublicUrl(path);
  }

  Future<String> uploadAvatar(
    Uint8List bytes, {
    String extension = 'jpg',
  }) async {
    final url = await uploadPhoto(
      bytes,
      folder: 'avatars',
      extension: extension,
    );
    await updateProfile(avatarUrl: url);
    return url;
  }

  Future<void> updateNotificationPrefs({
    bool? orderNotifications,
    bool? soundNotifications,
    bool? promoNotifications,
  }) async {
    final currentUser = user;
    if (currentUser == null) return;
    await _client
        .from('profiles')
        .update({
          'order_notifications': ?orderNotifications,
          'sound_notifications': ?soundNotifications,
          'promo_notifications': ?promoNotifications,
        })
        .eq('id', currentUser.id);
    await loadProfile();
  }

  Future<void> setNotifications(bool enabled) async {
    final currentUser = user;
    if (currentUser == null) return;
    await _client
        .from('profiles')
        .update({'notifications_enabled': enabled})
        .eq('id', currentUser.id);
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
    profile.value = null;
  }
}
