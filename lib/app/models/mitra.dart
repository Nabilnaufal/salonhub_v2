import 'package:flutter/material.dart';

import '../constant/theme.dart';

String formatRupiah(int amount) {
  final digits = amount.toString();
  final formatted = StringBuffer();

  for (var index = 0; index < digits.length; index++) {
    if (index > 0 && (digits.length - index) % 3 == 0) {
      formatted.write('.');
    }
    formatted.write(digits[index]);
  }

  return 'Rp$formatted';
}

enum MitraOrderStatus { baru, menunggu, diproses, selesai, dibatalkan }

extension MitraOrderStatusX on MitraOrderStatus {
  String get label {
    switch (this) {
      case MitraOrderStatus.baru:
        return 'Baru';
      case MitraOrderStatus.menunggu:
        return 'Menunggu';
      case MitraOrderStatus.diproses:
        return 'Diproses';
      case MitraOrderStatus.selesai:
        return 'Selesai';
      case MitraOrderStatus.dibatalkan:
        return 'Dibatalkan';
    }
  }

  String get description {
    switch (this) {
      case MitraOrderStatus.baru:
        return 'Pesanan baru menunggu konfirmasi';
      case MitraOrderStatus.menunggu:
        return 'Menunggu customer datang';
      case MitraOrderStatus.diproses:
        return 'Sedang dikerjakan barber';
      case MitraOrderStatus.selesai:
        return 'Layanan sudah selesai';
      case MitraOrderStatus.dibatalkan:
        return 'Pesanan dibatalkan';
    }
  }

  Color get color {
    switch (this) {
      case MitraOrderStatus.baru:
        return AppColors.blue700;
      case MitraOrderStatus.menunggu:
        return AppColors.yellow700;
      case MitraOrderStatus.diproses:
        return AppColors.secondary900;
      case MitraOrderStatus.selesai:
        return AppColors.teal700;
      case MitraOrderStatus.dibatalkan:
        return AppColors.red600;
    }
  }

  Color get backgroundColor {
    switch (this) {
      case MitraOrderStatus.baru:
        return AppColors.blue50;
      case MitraOrderStatus.menunggu:
        return AppColors.yellow50;
      case MitraOrderStatus.diproses:
        return AppColors.secondary50;
      case MitraOrderStatus.selesai:
        return AppColors.teal50;
      case MitraOrderStatus.dibatalkan:
        return AppColors.red50;
    }
  }

  String get iconAsset {
    switch (this) {
      case MitraOrderStatus.baru:
        return 'lib/assets/icons/Calendar outline.svg';
      case MitraOrderStatus.menunggu:
        return 'lib/assets/icons/Stopwatch.svg';
      case MitraOrderStatus.diproses:
        return 'lib/assets/icons/Scissors.svg';
      case MitraOrderStatus.selesai:
        return 'lib/assets/icons/Verified Check outline.svg';
      case MitraOrderStatus.dibatalkan:
        return 'lib/assets/icons/Close Square.svg';
    }
  }
}

class MitraOrderService {
  const MitraOrderService({
    required this.name,
    required this.price,
    required this.durationMinutes,
  });

  final String name;
  final int price;
  final int durationMinutes;
}

class MitraOrder {
  const MitraOrder({
    required this.id,
    required this.customerName,
    required this.customerImage,
    required this.customerPhone,
    required this.services,
    required this.barberName,
    required this.barberImage,
    required this.dateLabel,
    required this.timeLabel,
    required this.status,
    required this.paymentMethod,
    required this.note,
    required this.isPaid,
  });

  final String id;
  final String customerName;
  final String customerImage;
  final String customerPhone;
  final List<MitraOrderService> services;
  final String barberName;
  final String barberImage;
  final String dateLabel;
  final String timeLabel;
  final MitraOrderStatus status;
  final String paymentMethod;
  final String note;
  final bool isPaid;

  int get totalPrice =>
      services.fold(0, (total, service) => total + service.price);

  int get totalDuration =>
      services.fold(0, (total, service) => total + service.durationMinutes);

  String get serviceSummary =>
      services.map((service) => service.name).join(', ');

  MitraOrder copyWith({MitraOrderStatus? status}) {
    return MitraOrder(
      id: id,
      customerName: customerName,
      customerImage: customerImage,
      customerPhone: customerPhone,
      services: services,
      barberName: barberName,
      barberImage: barberImage,
      dateLabel: dateLabel,
      timeLabel: timeLabel,
      status: status ?? this.status,
      paymentMethod: paymentMethod,
      note: note,
      isPaid: isPaid,
    );
  }
}

class MitraService {
  const MitraService({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.durationMinutes,
    required this.image,
    required this.isActive,
    required this.totalBookings,
  });

  final String id;
  final String name;
  final String description;
  final int price;
  final int durationMinutes;
  final String image;
  final bool isActive;
  final int totalBookings;

  MitraService copyWith({
    String? name,
    String? description,
    int? price,
    int? durationMinutes,
    String? image,
    bool? isActive,
  }) {
    return MitraService(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      image: image ?? this.image,
      isActive: isActive ?? this.isActive,
      totalBookings: totalBookings,
    );
  }
}

class MitraTeamMember {
  const MitraTeamMember({
    required this.id,
    required this.name,
    required this.role,
    required this.rating,
    required this.image,
    required this.isActive,
    required this.todayBookings,
    required this.shift,
  });

  final String id;
  final String name;
  final String role;
  final double rating;
  final String image;
  final bool isActive;
  final int todayBookings;
  final String shift;

  MitraTeamMember copyWith({
    String? name,
    String? role,
    String? image,
    bool? isActive,
    String? shift,
  }) {
    return MitraTeamMember(
      id: id,
      name: name ?? this.name,
      role: role ?? this.role,
      rating: rating,
      image: image ?? this.image,
      isActive: isActive ?? this.isActive,
      todayBookings: todayBookings,
      shift: shift ?? this.shift,
    );
  }
}

class MitraReview {
  const MitraReview({
    required this.id,
    required this.customerName,
    required this.customerImage,
    required this.rating,
    required this.comment,
    required this.dateLabel,
    this.reply,
    this.serviceName = 'Basic haircut',
  });

  final String id;
  final String customerName;
  final String customerImage;
  final double rating;
  final String comment;
  final String dateLabel;
  final String? reply;
  final String serviceName;

  MitraReview copyWith({String? reply}) {
    return MitraReview(
      id: id,
      customerName: customerName,
      customerImage: customerImage,
      rating: rating,
      comment: comment,
      dateLabel: dateLabel,
      reply: reply ?? this.reply,
      serviceName: serviceName,
    );
  }
}

class MitraOpeningHour {
  const MitraOpeningHour({
    required this.day,
    required this.hours,
    this.isClosed = false,
  });

  final String day;
  final String hours;
  final bool isClosed;
}

class MitraShop {
  const MitraShop({
    required this.name,
    required this.description,
    required this.address,
    required this.distanceLabel,
    required this.image,
    required this.rating,
    required this.reviewCount,
    required this.phone,
    required this.facilities,
    required this.gallery,
    required this.openingHours,
  });

  final String name;
  final String description;
  final String address;
  final String distanceLabel;
  final String image;
  final double rating;
  final int reviewCount;
  final String phone;
  final List<String> facilities;
  final List<String> gallery;
  final List<MitraOpeningHour> openingHours;

  MitraShop copyWith({
    String? name,
    String? description,
    String? address,
    String? distanceLabel,
    String? image,
    double? rating,
    int? reviewCount,
    String? phone,
    List<String>? facilities,
    List<String>? gallery,
    List<MitraOpeningHour>? openingHours,
  }) {
    return MitraShop(
      name: name ?? this.name,
      description: description ?? this.description,
      address: address ?? this.address,
      distanceLabel: distanceLabel ?? this.distanceLabel,
      image: image ?? this.image,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      phone: phone ?? this.phone,
      facilities: facilities ?? this.facilities,
      gallery: gallery ?? this.gallery,
      openingHours: openingHours ?? this.openingHours,
    );
  }
}
