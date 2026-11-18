import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salonhub_v2/app/data/mitra_data_service.dart';
import 'package:salonhub_v2/app/models/mitra.dart';

class MitraReviewsController extends GetxController {
  final data = Get.find<MitraDataService>();

  final selectedRating = Rxn<int>();

  @override
  void onInit() {
    data.load();
    super.onInit();
  }

  List<MitraReview> get filteredReviews {
    final rating = selectedRating.value;
    if (rating == null) {
      return data.reviews.toList();
    }
    return data.reviews
        .where((review) => review.rating.round() == rating)
        .toList();
  }

  int countForRating(int rating) {
    return data.reviews
        .where((review) => review.rating.round() == rating)
        .length;
  }

  double get averageRating => data.averageRating;

  void selectRating(int? rating) {
    selectedRating.value = rating;
  }

  Future<void> openReply(MitraReview review) async {
    final replyController = TextEditingController(text: review.reply ?? '');
    final result = await Get.dialog<String>(
      AlertDialog(
        title: Text(review.reply == null ? 'Balas ulasan' : 'Ubah balasan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${review.customerName} • ${review.rating.toStringAsFixed(1)} ★',
              style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: replyController,
              maxLines: 4,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Tulis balasan yang ramah...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Batal')),
          FilledButton(
            onPressed: () => Get.back(result: replyController.text),
            child: const Text('Kirim'),
          ),
        ],
      ),
    );
    replyController.dispose();

    final reply = result?.trim();
    if (reply != null && reply.isNotEmpty) {
      await data.replyToReview(review.id, reply);
    }
  }
}
