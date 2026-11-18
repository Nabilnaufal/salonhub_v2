import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/barber.dart';

class ShopDetail {
  const ShopDetail({
    required this.shop,
    required this.hours,
    required this.services,
    required this.barbers,
    required this.reviews,
  });

  final Map<String, dynamic> shop;
  final List<Map<String, dynamic>> hours;
  final List<Map<String, dynamic>> services;
  final List<Map<String, dynamic>> barbers;
  final List<Map<String, dynamic>> reviews;
}

/// Data katalog publik: barbershop, layanan, barber, ulasan, booking.
class CatalogService extends GetxService {
  SupabaseClient get _client => Supabase.instance.client;

  final shops = <Barber>[].obs;
  final isLoading = false.obs;

  /// Nama layanan aktif per toko, untuk filter kategori.
  final serviceNamesByShop = <String, Set<String>>{};

  Future<List<Barber>> loadShops({
    double? minRating,
    double? maxDistanceKm,
    String? serviceQuery,
  }) async {
    isLoading.value = true;
    try {
      final rows = await _client
          .from('shops')
          .select()
          .order('rating', ascending: false);
      final services = await _client
          .from('shop_services')
          .select('shop_id, name')
          .eq('is_active', true);
      serviceNamesByShop
        ..clear()
        ..addAll({});
      for (final row in services) {
        final shopId = row['shop_id'] as String;
        (serviceNamesByShop[shopId] ??= <String>{}).add(
          (row['name'] as String).toLowerCase(),
        );
      }

      final result =
          rows
              .map((row) => Barber.fromShop(row.cast<String, dynamic>()))
              .where(
                (shop) =>
                    (minRating == null ||
                        double.parse(shop.rating) >= minRating) &&
                    (maxDistanceKm == null ||
                        shop.distanceKm <= maxDistanceKm) &&
                    (serviceQuery == null ||
                        serviceQuery.isEmpty ||
                        (serviceNamesByShop[shop.id] ?? const <String>{}).any(
                          (name) => name.contains(serviceQuery.toLowerCase()),
                        )),
              )
              .toList()
            ..sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
      shops.assignAll(result);
      return shops;
    } finally {
      isLoading.value = false;
    }
  }

  /// Booking toko pada satu hari (WIB), dipakai tab Jadwal customer.
  /// RPC hanya membuka jam + barber, bukan data customer.
  Future<List<Map<String, dynamic>>> loadDayBookings(
    String shopId,
    DateTime day,
  ) async {
    final rows = await _client.rpc(
      'shop_day_slots',
      params: {
        'p_shop_id': shopId,
        'p_day':
            '${day.year.toString().padLeft(4, '0')}-'
            '${day.month.toString().padLeft(2, '0')}-'
            '${day.day.toString().padLeft(2, '0')}',
      },
    );
    return (rows as List)
        .map((row) => Map<String, dynamic>.from(row as Map))
        .toList();
  }

  /// Jam yang sudah dipakai (WIB) pada satu tanggal.
  Future<Set<String>> bookedSlots(
    String shopId,
    DateTime day, {
    String? barberId,
  }) async {
    final rows = await _client.rpc(
      'booked_slots',
      params: {
        'p_shop_id': shopId,
        'p_day':
            '${day.year.toString().padLeft(4, '0')}-'
            '${day.month.toString().padLeft(2, '0')}-'
            '${day.day.toString().padLeft(2, '0')}',
        'p_barber_id': barberId,
      },
    );
    return (rows as List)
        .map((row) => (row as Map)['slot'] as String)
        .map((slot) => slot.substring(0, 5).replaceAll(':', '.'))
        .toSet();
  }

  /// Jumlah pesan belum dibaca per percakapan.
  Future<Map<String, int>> unreadCounts() async {
    final rows = await _client.rpc('unread_counts');
    return {
      for (final row in rows as List)
        (row as Map)['conversation_id'] as String: (row['unread'] as num)
            .toInt(),
    };
  }

  Future<void> markConversationRead(String conversationId) async {
    final uid = _client.auth.currentUser?.id;
    if (uid == null) return;
    await _client
        .from('messages')
        .update({'is_read': true})
        .eq('conversation_id', conversationId)
        .neq('sender_id', uid)
        .eq('is_read', false);
  }

  Future<Map<String, dynamic>> createWalkIn({
    required String shopId,
    required List<String> serviceIds,
    required DateTime scheduledAt,
    required String customerName,
    String? barberId,
    String note = '',
    String paymentMethod = 'cash',
  }) async {
    final row = await _client.rpc(
      'walk_in_booking',
      params: {
        'p_shop_id': shopId,
        'p_service_ids': serviceIds,
        'p_scheduled_at': scheduledAt.toUtc().toIso8601String(),
        'p_customer_name': customerName,
        'p_barber_id': barberId,
        'p_note': note,
        'p_payment_method': paymentMethod,
      },
    );
    return (row as Map).cast<String, dynamic>();
  }

  /// Toko favorit customer (dipakai daftar "Favorit").
  Future<Set<String>> favoriteShopIds() async {
    final uid = _client.auth.currentUser?.id;
    if (uid == null) return const {};
    final rows = await _client
        .from('favorites')
        .select('shop_id')
        .eq('customer_id', uid);
    return rows.map((row) => row['shop_id'] as String).toSet();
  }

  Future<bool> isFavorite(String shopId) async {
    final uid = _client.auth.currentUser?.id;
    if (uid == null) return false;
    final row = await _client
        .from('favorites')
        .select()
        .eq('customer_id', uid)
        .eq('shop_id', shopId)
        .maybeSingle();
    return row != null;
  }

  Future<bool> toggleFavorite(String shopId) async {
    final uid = _client.auth.currentUser?.id;
    if (uid == null) return false;
    if (await isFavorite(shopId)) {
      await _client
          .from('favorites')
          .delete()
          .eq('customer_id', uid)
          .eq('shop_id', shopId);
      return false;
    }
    await _client.from('favorites').insert({
      'customer_id': uid,
      'shop_id': shopId,
    });
    return true;
  }

  Future<void> sendSupportMessage({
    required String name,
    required String email,
    required String body,
  }) async {
    final uid = _client.auth.currentUser?.id;
    if (uid == null) throw StateError('harus login');
    await _client.from('support_messages').insert({
      'user_id': uid,
      'name': name,
      'email': email,
      'body': body,
    });
  }

  Future<ShopDetail> loadShop(String shopId) async {
    final results = await Future.wait([
      _client.from('shops').select().eq('id', shopId).single(),
      _client
          .from('shop_opening_hours')
          .select()
          .eq('shop_id', shopId)
          .order('day_of_week'),
      _client
          .from('shop_services')
          .select()
          .eq('shop_id', shopId)
          .eq('is_active', true)
          .order('price'),
      _client
          .from('barbers')
          .select()
          .eq('shop_id', shopId)
          .eq('is_active', true)
          .order('name'),
      _client
          .from('reviews')
          .select()
          .eq('shop_id', shopId)
          .order('created_at', ascending: false)
          .limit(20),
    ]);

    final reviews = (results[4] as List)
        .map((row) => Map<String, dynamic>.from(row as Map))
        .toList();
    if (reviews.isNotEmpty) {
      final ids = reviews.map((row) => row['customer_id']).toSet().toList();
      final profiles = await _client
          .from('public_profiles')
          .select()
          .inFilter('id', ids);
      final byId = {for (final row in profiles) row['id'] as String: row};
      for (final review in reviews) {
        review['public_profiles'] = byId[review['customer_id']];
      }
    }

    return ShopDetail(
      shop: Map<String, dynamic>.from(results[0] as Map),
      hours: (results[1] as List)
          .map((row) => Map<String, dynamic>.from(row as Map))
          .toList(),
      services: (results[2] as List)
          .map((row) => Map<String, dynamic>.from(row as Map))
          .toList(),
      barbers: (results[3] as List)
          .map((row) => Map<String, dynamic>.from(row as Map))
          .toList(),
      reviews: reviews,
    );
  }

  /// Koordinat toko untuk membuka peta.
  Future<(double, double)?> shopCoordinates(String shopId) async {
    final row = await _client
        .from('shops')
        .select('latitude, longitude')
        .eq('id', shopId)
        .maybeSingle();
    final lat = (row?['latitude'] as num?)?.toDouble();
    final lng = (row?['longitude'] as num?)?.toDouble();
    if (lat == null || lng == null) return null;
    return (lat, lng);
  }

  Future<Map<String, dynamic>> createBooking({
    required String shopId,
    required List<String> serviceIds,
    required DateTime scheduledAt,
    String? barberId,
    String note = '',
    String? paymentMethod,
  }) async {
    final row = await _client.rpc(
      'create_booking',
      params: {
        'p_shop_id': shopId,
        'p_service_ids': serviceIds,
        'p_scheduled_at': scheduledAt.toUtc().toIso8601String(),
        'p_barber_id': barberId,
        'p_note': note,
        'p_payment_method': paymentMethod,
      },
    );
    return (row as Map).cast<String, dynamic>();
  }

  Future<void> markBookingPaid(String bookingId, {String? method}) async {
    await _client
        .from('bookings')
        .update({'is_paid': true, 'payment_method': ?method})
        .eq('id', bookingId);
  }

  Future<void> cancelBooking(String bookingId) async {
    await _client
        .from('bookings')
        .update({'status': 'cancelled'})
        .eq('id', bookingId);
  }

  Future<Map<String, dynamic>> ensureConversation(String shopId) async {
    final uid = _client.auth.currentUser!.id;
    final existing = await _client
        .from('conversations')
        .select()
        .eq('customer_id', uid)
        .eq('shop_id', shopId)
        .maybeSingle();
    if (existing != null) return existing;

    return await _client
        .from('conversations')
        .insert({'customer_id': uid, 'shop_id': shopId})
        .select()
        .single();
  }

  Future<List<Map<String, dynamic>>> loadConversations() async {
    final uid = _client.auth.currentUser?.id;
    if (uid == null) return const [];

    final rows = await _client
        .from('conversations')
        .select()
        .eq('customer_id', uid)
        .order('last_message_at', ascending: false);

    final unread = await unreadCounts();
    final shops = await _client.from('shops').select('id, name, image_url');
    final byId = {for (final row in shops) row['id'] as String: row};

    return rows.map((row) {
      final map = row.cast<String, dynamic>();
      final shop = byId[map['shop_id']];
      map['shop_name'] = shop?['name'] ?? 'Barbershop';
      map['shop_image'] = shop?['image_url'];
      map['unread'] = unread[map['id']] ?? 0;
      return map;
    }).toList();
  }

  Future<Map<String, dynamic>> sendMessage(
    String conversationId,
    String body,
  ) async {
    final uid = _client.auth.currentUser!.id;
    return await _client
        .from('messages')
        .insert({
          'conversation_id': conversationId,
          'sender_id': uid,
          'body': body,
        })
        .select()
        .single();
  }

  Future<List<Map<String, dynamic>>> loadMessages(String conversationId) async {
    final rows = await _client
        .from('messages')
        .select()
        .eq('conversation_id', conversationId)
        .order('created_at');
    return rows.map((row) => Map<String, dynamic>.from(row)).toList();
  }

  Stream<List<Map<String, dynamic>>> messagesStream(String conversationId) {
    return _client
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('conversation_id', conversationId)
        .order('created_at')
        .map(
          (rows) => rows.map((row) => Map<String, dynamic>.from(row)).toList(),
        );
  }

  Future<void> submitReview({
    required String bookingId,
    required String shopId,
    required int rating,
    required String comment,
  }) async {
    await _client.from('reviews').insert({
      'booking_id': bookingId,
      'shop_id': shopId,
      'customer_id': _client.auth.currentUser!.id,
      'rating': rating,
      'comment': comment,
    });
  }
}
