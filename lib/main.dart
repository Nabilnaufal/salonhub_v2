import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/constant/theme.dart';
import 'app/data/mitra_data_service.dart';
import 'app/routes/app_pages.dart';
import 'app/services/auth_service.dart';
import 'app/services/catalog_service.dart';

Future<void> main() async {
  // Inisialisasi Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Supabase
  await Supabase.initialize(
    url: 'https://yjmhqpsovlhanglpepmz.supabase.co',
    publishableKey: 'sb_publishable_Xmd3JULqid9uzVNWxRbHnA_hc44haXC',
  );

  // Dependency Injection GetX
  Get.put(AuthService(), permanent: true);
  Get.put(CatalogService(), permanent: true);
  Get.put(MitraDataService(), permanent: true);

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Application',
      theme: AppTheme.light,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
