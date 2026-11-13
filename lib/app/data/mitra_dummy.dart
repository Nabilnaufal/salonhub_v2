import '../models/mitra.dart';

/// Data dummy untuk keperluan tampilan sisi mitra.
/// Tidak ada koneksi jaringan atau backend pada tahap ini.
abstract final class MitraDummy {
  MitraDummy._();

  static const shop = MitraShop(
    name: 'Masterpiece Barbershop',
    description:
        'Di Masterpiece Barbershop, tim ahli cukur kami yang berpengalaman '
        'siap memberikan hasil terbaik dan mengubah penampilan rambutmu.',
    address: 'Jl. Kaliurang KM 5, No. 18, Sleman, Yogyakarta',
    distanceLabel: '2 km dari lokasimu',
    image: 'lib/assets/barbershop_haircut_2.jpg',
    rating: 4.9,
    reviewCount: 128,
    phone: '0812 3456 7890',
    facilities: [
      'AC',
      'WiFi',
      'Free Drink',
      'TV',
      'Parkir',
      'Card Payment',
      'Musala',
    ],
    gallery: [
      'lib/assets/barbershop_interior_1.jpg',
      'lib/assets/barbershop_interior_2.jpg',
      'lib/assets/barbershop_haircut_1.jpg',
      'lib/assets/barbershop_exterior_1.jpg',
    ],
    openingHours: [
      MitraOpeningHour(day: 'Senin', hours: '09.00 - 20.00'),
      MitraOpeningHour(day: 'Selasa', hours: '09.00 - 20.00'),
      MitraOpeningHour(day: 'Rabu', hours: '09.00 - 20.00'),
      MitraOpeningHour(day: 'Kamis', hours: '09.00 - 20.00'),
      MitraOpeningHour(day: 'Jumat', hours: '09.00 - 21.00'),
      MitraOpeningHour(day: 'Sabtu', hours: '09.00 - 21.00'),
      MitraOpeningHour(day: 'Minggu', hours: '10.00 - 18.00'),
    ],
  );

  static const services = <MitraService>[
    MitraService(
      id: 'svc-1',
      name: 'Basic haircut',
      description: 'Potong rambut dasar & vitamin',
      price: 20000,
      durationMinutes: 30,
      image: 'lib/assets/barbershop_haircut_3.jpg',
      isActive: true,
      totalBookings: 86,
    ),
    MitraService(
      id: 'svc-2',
      name: 'Kids haircut',
      description: 'Potong rambut khusus anak',
      price: 15000,
      durationMinutes: 25,
      image: 'lib/assets/barbershop_exterior_1.jpg',
      isActive: true,
      totalBookings: 34,
    ),
    MitraService(
      id: 'svc-3',
      name: 'Hair coloring',
      description: 'Pewarnaan rambut pilihan',
      price: 30000,
      durationMinutes: 60,
      image: 'lib/assets/barbershop_haircut_1.jpg',
      isActive: true,
      totalBookings: 21,
    ),
    MitraService(
      id: 'svc-4',
      name: 'Hair treatment',
      description: 'Perawatan rambut & scalp massage',
      price: 10000,
      durationMinutes: 20,
      image: 'lib/assets/barbershop_interior_2.jpg',
      isActive: true,
      totalBookings: 42,
    ),
    MitraService(
      id: 'svc-5',
      name: 'Special massage',
      description: 'Pijat kepala & bahu tambahan',
      price: 10000,
      durationMinutes: 15,
      image: 'lib/assets/barbershop_interior_1.jpg',
      isActive: false,
      totalBookings: 12,
    ),
  ];

  static const team = <MitraTeamMember>[
    MitraTeamMember(
      id: 'tm-1',
      name: 'Luther Hammes',
      role: 'Specialist Haircut',
      rating: 5.0,
      image: 'lib/assets/barbershop_haircut_3.jpg',
      isActive: true,
      todayBookings: 4,
      shift: '09.00 - 17.00',
    ),
    MitraTeamMember(
      id: 'tm-2',
      name: 'Emanuel Bernier',
      role: 'Specialist Coloring',
      rating: 4.5,
      image: 'lib/assets/barbershop_haircut_1.jpg',
      isActive: true,
      todayBookings: 3,
      shift: '10.00 - 18.00',
    ),
    MitraTeamMember(
      id: 'tm-3',
      name: 'Karl Vandervort',
      role: 'Specialist Treatment',
      rating: 4.5,
      image: 'lib/assets/barbershop_interior_1.jpg',
      isActive: true,
      todayBookings: 2,
      shift: '12.00 - 20.00',
    ),
    MitraTeamMember(
      id: 'tm-4',
      name: 'Sergio Wilderman',
      role: 'Barber',
      rating: 4.8,
      image: 'lib/assets/barbershop_interior_2.jpg',
      isActive: false,
      todayBookings: 0,
      shift: 'Libur',
    ),
  ];

  static const orders = <MitraOrder>[
    MitraOrder(
      id: 'SBH-260115-0800',
      customerName: 'Alan Cartwright',
      customerImage: 'lib/assets/barbershop_haircut_3.jpg',
      customerPhone: '0812 1111 2233',
      services: [
        MitraOrderService(
          name: 'Basic haircut',
          price: 20000,
          durationMinutes: 30,
        ),
        MitraOrderService(
          name: 'Hair treatment',
          price: 10000,
          durationMinutes: 20,
        ),
      ],
      barberName: 'Luther Hammes',
      barberImage: 'lib/assets/barbershop_haircut_3.jpg',
      dateLabel: 'Hari ini, 15 Jan 2026',
      timeLabel: '08.00 WIB',
      status: MitraOrderStatus.baru,
      paymentMethod: 'QRIS',
      note: 'Minta model undercut rapi ya bang.',
      isPaid: true,
    ),
    MitraOrder(
      id: 'SBH-260115-0830',
      customerName: 'Robert Gleichner',
      customerImage: 'lib/assets/barbershop_haircut_1.jpg',
      customerPhone: '0813 2222 3344',
      services: [
        MitraOrderService(
          name: 'Hair coloring',
          price: 30000,
          durationMinutes: 60,
        ),
      ],
      barberName: 'Emanuel Bernier',
      barberImage: 'lib/assets/barbershop_haircut_1.jpg',
      dateLabel: 'Hari ini, 15 Jan 2026',
      timeLabel: '09.00 WIB',
      status: MitraOrderStatus.baru,
      paymentMethod: 'BCA',
      note: 'Warna coklat ash, jangan terlalu terang.',
      isPaid: true,
    ),
    MitraOrder(
      id: 'SBH-260115-0900',
      customerName: 'Sergio Wilderman',
      customerImage: 'lib/assets/barbershop_interior_2.jpg',
      customerPhone: '0857 3333 4455',
      services: [
        MitraOrderService(
          name: 'Basic haircut',
          price: 20000,
          durationMinutes: 30,
        ),
      ],
      barberName: 'Karl Vandervort',
      barberImage: 'lib/assets/barbershop_interior_1.jpg',
      dateLabel: 'Hari ini, 15 Jan 2026',
      timeLabel: '10.00 WIB',
      status: MitraOrderStatus.menunggu,
      paymentMethod: 'QRIS',
      note: '-',
      isPaid: true,
    ),
    MitraOrder(
      id: 'SBH-260115-1030',
      customerName: 'Miss Erik VonRueden',
      customerImage: 'lib/assets/barbershop_interior_1.jpg',
      customerPhone: '0821 4444 5566',
      services: [
        MitraOrderService(
          name: 'Kids haircut',
          price: 15000,
          durationMinutes: 25,
        ),
        MitraOrderService(
          name: 'Special massage',
          price: 10000,
          durationMinutes: 15,
        ),
      ],
      barberName: 'Luther Hammes',
      barberImage: 'lib/assets/barbershop_haircut_3.jpg',
      dateLabel: 'Hari ini, 15 Jan 2026',
      timeLabel: '10.30 WIB',
      status: MitraOrderStatus.diproses,
      paymentMethod: 'Mandiri',
      note: 'Anak laki-laki usia 7 tahun.',
      isPaid: true,
    ),
    MitraOrder(
      id: 'SBH-260115-1300',
      customerName: 'Nadia Puspita',
      customerImage: 'lib/assets/barbershop_haircut_2.jpg',
      customerPhone: '0819 5555 6677',
      services: [
        MitraOrderService(
          name: 'Hair treatment',
          price: 10000,
          durationMinutes: 20,
        ),
      ],
      barberName: 'Karl Vandervort',
      barberImage: 'lib/assets/barbershop_interior_1.jpg',
      dateLabel: 'Hari ini, 15 Jan 2026',
      timeLabel: '13.00 WIB',
      status: MitraOrderStatus.selesai,
      paymentMethod: 'QRIS',
      note: '-',
      isPaid: true,
    ),
    MitraOrder(
      id: 'SBH-260114-1600',
      customerName: 'Bagas Pratama',
      customerImage: 'lib/assets/barbershop_exterior_1.jpg',
      customerPhone: '0812 6666 7788',
      services: [
        MitraOrderService(
          name: 'Hair coloring',
          price: 30000,
          durationMinutes: 60,
        ),
      ],
      barberName: 'Emanuel Bernier',
      barberImage: 'lib/assets/barbershop_haircut_1.jpg',
      dateLabel: 'Kemarin, 14 Jan 2026',
      timeLabel: '16.00 WIB',
      status: MitraOrderStatus.selesai,
      paymentMethod: 'BRI',
      note: '-',
      isPaid: true,
    ),
    MitraOrder(
      id: 'SBH-260114-1730',
      customerName: 'Dinda Larasati',
      customerImage: 'lib/assets/barbershop_interior_2.jpg',
      customerPhone: '0857 7777 8899',
      services: [
        MitraOrderService(
          name: 'Basic haircut',
          price: 20000,
          durationMinutes: 30,
        ),
      ],
      barberName: 'Luther Hammes',
      barberImage: 'lib/assets/barbershop_haircut_3.jpg',
      dateLabel: 'Kemarin, 14 Jan 2026',
      timeLabel: '17.30 WIB',
      status: MitraOrderStatus.dibatalkan,
      paymentMethod: 'QRIS',
      note: 'Customer berhalangan hadir.',
      isPaid: false,
    ),
  ];

  static const reviews = <MitraReview>[
    MitraReview(
      id: 'rv-1',
      customerName: 'Alan Cartwright',
      customerImage: 'lib/assets/barbershop_haircut_3.jpg',
      rating: 4.0,
      comment:
          'Good service, recommendation for barber shop seekers. Tempatnya '
          'bersih dan barbernya ramah.',
      dateLabel: '2 hari lalu',
      serviceName: 'Basic haircut',
    ),
    MitraReview(
      id: 'rv-2',
      customerName: 'Robert Gleichner',
      customerImage: 'lib/assets/barbershop_haircut_1.jpg',
      rating: 5.0,
      comment:
          'Place is not too far and the shaving results are good. Pasti '
          'balik lagi kesini.',
      dateLabel: '4 hari lalu',
      serviceName: 'Hair coloring',
      reply: 'Terima kasih kak Robert, ditunggu kedatangannya lagi!',
    ),
    MitraReview(
      id: 'rv-3',
      customerName: 'Sergio Wilderman',
      customerImage: 'lib/assets/barbershop_interior_2.jpg',
      rating: 4.0,
      comment:
          'Price is quite affordable and the service is good, I am very '
          'satisfied.',
      dateLabel: '1 minggu lalu',
      serviceName: 'Kids haircut',
    ),
    MitraReview(
      id: 'rv-4',
      customerName: 'Miss Erik VonRueden',
      customerImage: 'lib/assets/barbershop_interior_1.jpg',
      rating: 5.0,
      comment:
          'Style of barbering here really follows the times, like the '
          'service. Recommended!',
      dateLabel: '1 minggu lalu',
      serviceName: 'Hair treatment',
    ),
    MitraReview(
      id: 'rv-5',
      customerName: 'Nadia Puspita',
      customerImage: 'lib/assets/barbershop_haircut_2.jpg',
      rating: 3.0,
      comment: 'Hasilnya oke, tapi antreannya agak lama karena sedang ramai.',
      dateLabel: '2 minggu lalu',
      serviceName: 'Basic haircut',
    ),
  ];

  static const weeklyRevenue = <int>[
    850000,
    1200000,
    700000,
    1450000,
    980000,
    1650000,
    1250000,
  ];

  static const weeklyLabels = <String>[
    'Sen',
    'Sel',
    'Rab',
    'Kam',
    'Jum',
    'Sab',
    'Min',
  ];

  static const transactions =
      <({String title, String subtitle, int amount, bool isIncome})>[
        (
          title: 'SBH-260115-1300',
          subtitle: 'Hair treatment • QRIS',
          amount: 10000,
          isIncome: true,
        ),
        (
          title: 'SBH-260115-1030',
          subtitle: 'Kids haircut + massage • Mandiri',
          amount: 25000,
          isIncome: true,
        ),
        (
          title: 'SBH-260114-1600',
          subtitle: 'Hair coloring • BRI',
          amount: 30000,
          isIncome: true,
        ),
        (
          title: 'Biaya layanan platform',
          subtitle: 'Potongan 5% dari transaksi',
          amount: 4500,
          isIncome: false,
        ),
        (
          title: 'SBH-260115-0900',
          subtitle: 'Basic haircut • QRIS',
          amount: 20000,
          isIncome: true,
        ),
      ];
}
