import 'package:get/get.dart';

import '../models/mitra.dart';
import 'mitra_dummy.dart';

/// Penyimpanan state lokal (in-memory) khusus tampilan mitra.
///
/// Tidak ada request jaringan, database, atau backend di sini. Semua data
/// awal berasal dari [MitraDummy] dan hanya bertahan selama aplikasi berjalan.
class MitraDataService extends GetxService {
  final shop = MitraDummy.shop.obs;
  final isShopOpen = true.obs;

  final orders = <MitraOrder>[...MitraDummy.orders].obs;
  final services = <MitraService>[...MitraDummy.services].obs;
  final team = <MitraTeamMember>[...MitraDummy.team].obs;
  final reviews = <MitraReview>[...MitraDummy.reviews].obs;

  List<MitraOrder> ordersByStatus(MitraOrderStatus? status) {
    if (status == null) {
      return orders.toList();
    }
    return orders.where((order) => order.status == status).toList();
  }

  List<MitraOrder> get todayOrders {
    return orders
        .where((order) => order.dateLabel.toLowerCase().contains('hari ini'))
        .toList();
  }

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

  int get todayRevenue => orders
      .where(
        (order) =>
            order.dateLabel.toLowerCase().contains('hari ini') &&
            order.isPaid &&
            order.status != MitraOrderStatus.dibatalkan,
      )
      .fold(0, (total, order) => total + order.totalPrice);

  double get averageRating {
    if (reviews.isEmpty) {
      return 0;
    }
    final total = reviews.fold<double>(0, (sum, review) => sum + review.rating);
    return total / reviews.length;
  }

  int get activeServicesCount =>
      services.where((service) => service.isActive).length;

  MitraOrder? findByCode(String code) {
    for (final order in orders) {
      if (order.id == code) {
        return order;
      }
    }
    return null;
  }

  void updateOrderStatus(String orderCode, MitraOrderStatus status) {
    final index = orders.indexWhere((order) => order.id == orderCode);
    if (index == -1) {
      return;
    }
    orders[index] = orders[index].copyWith(status: status);
  }

  void toggleShop() {
    isShopOpen.toggle();
  }

  void addService(MitraService service) {
    services.insert(0, service);
  }

  void updateService(MitraService service) {
    final index = services.indexWhere((item) => item.id == service.id);
    if (index == -1) {
      return;
    }
    services[index] = service;
  }

  void removeService(String id) {
    services.removeWhere((service) => service.id == id);
  }

  void toggleServiceStatus(String id) {
    final index = services.indexWhere((service) => service.id == id);
    if (index == -1) {
      return;
    }
    final service = services[index];
    services[index] = service.copyWith(isActive: !service.isActive);
  }

  void addTeamMember(MitraTeamMember member) {
    team.insert(0, member);
  }

  void updateTeamMember(MitraTeamMember member) {
    final index = team.indexWhere((item) => item.id == member.id);
    if (index == -1) {
      return;
    }
    team[index] = member;
  }

  void removeTeamMember(String id) {
    team.removeWhere((member) => member.id == id);
  }

  void toggleTeamMemberStatus(String id) {
    final index = team.indexWhere((member) => member.id == id);
    if (index == -1) {
      return;
    }
    final member = team[index];
    team[index] = member.copyWith(isActive: !member.isActive);
  }

  void replyToReview(String reviewId, String reply) {
    final index = reviews.indexWhere((review) => review.id == reviewId);
    if (index == -1) {
      return;
    }
    reviews[index] = reviews[index].copyWith(reply: reply);
  }

  void updateShop(MitraShop updatedShop) {
    shop.value = updatedShop;
  }
}
