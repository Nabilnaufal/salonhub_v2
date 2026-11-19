import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/mitra.dart';

MitraOrderStatus _statusFromDb(String value) {
  switch (value) {
    case 'waiting':
      return MitraOrderStatus.menunggu;
    case 'on_process':
      return MitraOrderStatus.diproses;
    case 'finished':
      return MitraOrderStatus.selesai;
    case 'cancelled':
      return MitraOrderStatus.dibatalkan;
    default:
      return MitraOrderStatus.baru;
  }
}

String _statusToDb(MitraOrderStatus status) {
  switch (status) {
    case MitraOrderStatus.baru:
      return 'booked';
    case MitraOrderStatus.menunggu:
      return 'waiting';
    case MitraOrderStatus.diproses:
      return 'on_process';
    case MitraOrderStatus.selesai:
      return 'finished';
    case MitraOrderStatus.dibatalkan:
      return 'cancelled';
  }
}

/// Semua data panel mitra dimuat dari Supabase.
class MitraDataService extends GetxService {
  SupabaseClient get _client => Supabase.instance.client;

  final shop = MitraShop(
    name: '',
    description: '',
    address: '',
    image: '',
    rating: 0,
    reviewCount: 0,
    phone: '',
    facilities: const [],
    gallery: const [],
    openingHours: const [],
  ).obs;
  final isShopOpen = true.obs;
  final isLoading = false.obs;

  final orders = <MitraOrder>[].obs;
  final services = <MitraService>[].obs;
  final team = <MitraTeamMember>[].obs;
  final reviews = <MitraReview>[].obs;
  final unreadChats = 0.obs;

  String? _shopId;
  String? get shopId => _shopId;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    final uid = _client.auth.currentUser?.id;
    if (uid == null) return;

    isLoading.value = true;
    try {
      Map<String, dynamic>? row = await _client
          .from('shops')
          .select()
          .eq('owner_id', uid)
          .maybeSingle();

      if (row == null) {
        // Mitra baru: buat toko dari metadata pendaftaran.
        final shopName =
            _client.auth.currentUser?.userMetadata?['shop_name'] as String?;
        if (shopName == null || shopName.isEmpty) return;
        try {
          row = (await _client.rpc('register_shop') as Map)
              .cast<String, dynamic>();
        } catch (_) {
          // Metadata toko tidak lengkap; panel menunggu data berikutnya.
          return;
        }
      }

      _shopId = row['id'] as String;
      isShopOpen.value = row['is_open'] as bool? ?? true;

      final results = await Future.wait([
        _client
            .from('shop_opening_hours')
            .select()
            .eq('shop_id', _shopId!)
            .order('day_of_week'),
        _client
            .from('shop_services')
            .select()
            .eq('shop_id', _shopId!)
            .order('created_at', ascending: false),
        _client
            .from('barbers')
            .select()
            .eq('shop_id', _shopId!)
            .order('created_at', ascending: false),
        _client
            .from('reviews')
            .select()
            .eq('shop_id', _shopId!)
            .order('created_at', ascending: false),
        _client
            .from('bookings')
            .select(
              '*, booking_items(name, price, duration_minutes), '
              'barbers(name, role, image_url)',
            )
            .eq('shop_id', _shopId!)
            .order('scheduled_at', ascending: false),
      ]);

      shop.value = MitraShop.fromMap(
        row,
        hours: (results[0] as List)
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList(),
      );
      services.assignAll(
        (results[1] as List).map(
          (e) => MitraService.fromMap(Map<String, dynamic>.from(e as Map)),
        ),
      );
      team.assignAll(
        (results[2] as List).map(
          (e) => MitraTeamMember.fromMap(Map<String, dynamic>.from(e as Map)),
        ),
      );

      final reviewRows = (results[3] as List)
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
      await _attachReviewProfiles(reviewRows);
      reviews.assignAll(reviewRows.map(MitraReview.fromMap));

      final bookingRows = (results[4] as List)
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
      orders.assignAll(await _attachCustomerProfiles(bookingRows));
      await loadUnreadChats();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadUnreadChats() async {
    try {
      final rows = await _client.rpc('unread_counts') as List;
      unreadChats.value = rows.fold<int>(
        0,
        (sum, row) => sum + ((row as Map)['unread'] as num).toInt(),
      );
    } catch (_) {
      // Biarkan angka sebelumnya bila gagal dimuat.
    }
  }

  Future<void> _attachReviewProfiles(List<Map<String, dynamic>> rows) async {
    if (rows.isEmpty) return;
    final ids = rows.map((row) => row['customer_id']).toSet().toList();
    final profiles = await _client
        .from('public_profiles')
        .select()
        .inFilter('id', ids);
    final byId = {for (final row in profiles) row['id'] as String: row};
    for (final row in rows) {
      row['public_profiles'] = byId[row['customer_id']];
    }
  }

  Future<List<MitraOrder>> _attachCustomerProfiles(
    List<Map<String, dynamic>> rows,
  ) async {
    if (rows.isEmpty) return const [];

    final ids = rows.map((row) => row['customer_id']).toSet().toList();
    final profiles = await _client
        .from('profiles')
        .select('id, full_name, avatar_url, phone')
        .inFilter('id', ids);
    final byId = {for (final row in profiles) row['id'] as String: row};

    return rows.map((row) {
      final profile = byId[row['customer_id']];
      final barber = row['barbers'] as Map?;
      final items = (row['booking_items'] as List? ?? [])
          .map((item) => item as Map)
          .toList();
      final scheduled = DateTime.parse(row['scheduled_at'] as String);

      return MitraOrder(
        id: row['id'] as String,
        customerName: profile?['full_name'] as String? ?? 'Customer',
        customerImage: profile?['avatar_url'] as String? ?? '',
        customerPhone: profile?['phone'] as String? ?? '',
        services: items
            .map(
              (item) => MitraOrderService(
                name: item['name'] as String,
                price: (item['price'] as num).toInt(),
                durationMinutes: (item['duration_minutes'] as num).toInt(),
              ),
            )
            .toList(),
        barberName: barber?['name'] as String? ?? '',
        barberImage: barber?['image_url'] as String? ?? '',
        dateLabel: formatDateLabel(scheduled),
        timeLabel: formatTimeLabel(scheduled),
        status: _statusFromDb(row['status'] as String),
        paymentMethod: row['payment_method'] as String? ?? '',
        note: row['note'] as String? ?? '',
        isPaid: row['is_paid'] as bool? ?? false,
        scheduledAt: scheduled,
      );
    }).toList();
  }

  List<MitraOrder> ordersByStatus(MitraOrderStatus? status) {
    if (status == null) return orders.toList();
    return orders.where((order) => order.status == status).toList();
  }

  List<MitraOrder> get todayOrders => orders
      .where((order) => order.dateLabel.toLowerCase().contains('hari ini'))
      .toList();

  int get newOrdersCount =>
      orders.where((order) => order.status == MitraOrderStatus.baru).length;

  int get activeOrdersCount => orders
      .where(
        (order) =>
            order.status == MitraOrderStatus.baru ||
            order.status == MitraOrderStatus.menunggu ||
            order.status == MitraOrderStatus.diproses,
      )
      .length;

  int _revenueOn(DateTime day) {
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));
    return orders
        .where((order) {
          final at = order.scheduledAt;
          return at != null &&
              !at.isBefore(start) &&
              at.isBefore(end) &&
              order.isPaid &&
              order.status != MitraOrderStatus.dibatalkan;
        })
        .fold(0, (total, order) => total + order.totalPrice);
  }

  int get todayRevenue => _revenueOn(DateTime.now());

  int get yesterdayRevenue =>
      _revenueOn(DateTime.now().subtract(const Duration(days: 1)));

  /// null bila belum ada pembanding (kemarin nol).
  int? get todayRevenueChangePercent {
    final previous = yesterdayRevenue;
    if (previous == 0) return null;
    return ((todayRevenue - previous) * 100 / previous).round();
  }

  int get newOrdersTodayCount {
    final now = DateTime.now();
    return orders.where((order) {
      final at = order.scheduledAt;
      return at != null &&
          at.year == now.year &&
          at.month == now.month &&
          at.day == now.day &&
          order.status == MitraOrderStatus.baru;
    }).length;
  }

  double get averageRating {
    if (reviews.isEmpty) return 0;
    final total = reviews.fold<double>(0, (sum, review) => sum + review.rating);
    return total / reviews.length;
  }

  int get activeServicesCount =>
      services.where((service) => service.isActive).length;

  MitraOrder? findByCode(String code) {
    for (final order in orders) {
      if (order.id == code) return order;
    }
    return null;
  }

  /// Pesanan walk-in: dibuat lewat RPC `walk_in_booking`.
  Future<void> addWalkIn({
    required DateTime scheduledAt,
    required String customerName,
    required List<String> serviceIds,
  }) async {
    final id = _shopId;
    if (id == null) throw StateError('toko belum siap');
    await _client.rpc(
      'walk_in_booking',
      params: {
        'p_shop_id': id,
        'p_service_ids': serviceIds,
        'p_scheduled_at': scheduledAt.toUtc().toIso8601String(),
        'p_customer_name': customerName,
        'p_barber_id': null,
        'p_note': 'Walk-in',
        'p_payment_method': 'cash',
      },
    );
    await load();
  }

  Future<void> updateOrderStatus(
    String orderId,
    MitraOrderStatus status,
  ) async {
    await _client
        .from('bookings')
        .update({'status': _statusToDb(status)})
        .eq('id', orderId);
    final index = orders.indexWhere((order) => order.id == orderId);
    if (index != -1) {
      orders[index] = orders[index].copyWith(status: status);
    }
  }

  Future<void> toggleShop() async {
    final id = _shopId;
    if (id == null) return;
    final next = !isShopOpen.value;
    await _client.from('shops').update({'is_open': next}).eq('id', id);
    isShopOpen.value = next;
    shop.value = shop.value.copyWith(isOpen: next);
  }

  Future<void> addService(MitraService service) async {
    final id = _shopId;
    if (id == null) return;
    await _client.from('shop_services').insert({
      'shop_id': id,
      'name': service.name,
      'description': service.description,
      'price': service.price,
      'duration_minutes': service.durationMinutes,
      'image_url': service.image.isEmpty ? null : service.image,
    });
    await _loadServices();
  }

  Future<void> updateService(MitraService service) async {
    await _client
        .from('shop_services')
        .update({
          'name': service.name,
          'description': service.description,
          'price': service.price,
          'duration_minutes': service.durationMinutes,
          'image_url': service.image.isEmpty ? null : service.image,
        })
        .eq('id', service.id);
    await _loadServices();
  }

  Future<void> removeService(String id) async {
    await _client.from('shop_services').delete().eq('id', id);
    services.removeWhere((service) => service.id == id);
  }

  Future<void> toggleServiceStatus(String id) async {
    final index = services.indexWhere((service) => service.id == id);
    if (index == -1) return;
    final service = services[index];
    await _client
        .from('shop_services')
        .update({'is_active': !service.isActive})
        .eq('id', id);
    services[index] = service.copyWith(isActive: !service.isActive);
  }

  Future<void> _loadServices() async {
    final id = _shopId;
    if (id == null) return;
    final rows = await _client
        .from('shop_services')
        .select()
        .eq('shop_id', id)
        .order('created_at', ascending: false);
    services.assignAll(
      rows.map((row) => MitraService.fromMap(row.cast<String, dynamic>())),
    );
  }

  Future<void> addTeamMember(MitraTeamMember member) async {
    final id = _shopId;
    if (id == null) return;
    await _client.from('barbers').insert({
      'shop_id': id,
      'name': member.name,
      'role': member.role,
      'image_url': member.image.isEmpty ? null : member.image,
      'shift_start': _shiftTime(member.shift, first: true),
      'shift_end': _shiftTime(member.shift, first: false),
    });
    await _loadTeam();
  }

  Future<void> updateTeamMember(MitraTeamMember member) async {
    await _client
        .from('barbers')
        .update({
          'name': member.name,
          'role': member.role,
          'image_url': member.image.isEmpty ? null : member.image,
          'shift_start': _shiftTime(member.shift, first: true),
          'shift_end': _shiftTime(member.shift, first: false),
        })
        .eq('id', member.id);
    await _loadTeam();
  }

  Future<void> removeTeamMember(String id) async {
    await _client.from('barbers').delete().eq('id', id);
    team.removeWhere((member) => member.id == id);
  }

  Future<void> toggleTeamMemberStatus(String id) async {
    final index = team.indexWhere((member) => member.id == id);
    if (index == -1) return;
    final member = team[index];
    await _client
        .from('barbers')
        .update({'is_active': !member.isActive})
        .eq('id', id);
    team[index] = member.copyWith(isActive: !member.isActive);
  }

  String? _shiftTime(String shift, {required bool first}) {
    final parts = shift.split('-');
    final value = (first ? parts.first : parts.last).trim();
    if (value.length != 5 || !value.contains('.')) return null;
    return value.replaceAll('.', ':');
  }

  Future<void> _loadTeam() async {
    final id = _shopId;
    if (id == null) return;
    final rows = await _client
        .from('barbers')
        .select()
        .eq('shop_id', id)
        .order('created_at', ascending: false);
    team.assignAll(
      rows.map((row) => MitraTeamMember.fromMap(row.cast<String, dynamic>())),
    );
  }

  Future<void> replyToReview(String reviewId, String reply) async {
    await _client
        .from('reviews')
        .update({
          'reply': reply,
          'replied_at': DateTime.now().toUtc().toIso8601String(),
        })
        .eq('id', reviewId);
    final index = reviews.indexWhere((review) => review.id == reviewId);
    if (index != -1) {
      reviews[index] = reviews[index].copyWith(reply: reply);
    }
  }

  Future<void> updateShop(MitraShop updatedShop) async {
    final id = _shopId;
    if (id == null) return;
    await _client
        .from('shops')
        .update({
          'name': updatedShop.name,
          'description': updatedShop.description,
          'address': updatedShop.address,
          'phone': updatedShop.phone,
          'image_url': updatedShop.image.isEmpty ? null : updatedShop.image,
          'facilities': updatedShop.facilities,
          'gallery': updatedShop.gallery,
          'latitude': updatedShop.latitude,
          'longitude': updatedShop.longitude,
        })
        .eq('id', id);
    await load();
  }

  /// Simpan jam operasional (Senin..Minggu, tutup memakai is_closed).
  Future<void> updateOpeningHours(
    List<({int day, String open, String close, bool isClosed})> hours,
  ) async {
    final id = _shopId;
    if (id == null) return;
    await _client
        .from('shop_opening_hours')
        .upsert(
          hours
              .map(
                (hour) => {
                  'shop_id': id,
                  'day_of_week': hour.day,
                  'open_time': hour.isClosed ? null : hour.open,
                  'close_time': hour.isClosed ? null : hour.close,
                  'is_closed': hour.isClosed,
                },
              )
              .toList(),
          onConflict: 'shop_id,day_of_week',
        );
    await load();
  }
}
