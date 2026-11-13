import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/constant/theme.dart';
import 'app/data/mitra_data_service.dart';
import 'app/routes/app_pages.dart';

void main() {
  Get.put(MitraDataService(), permanent: true);

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Application",
      theme: AppTheme.light,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
