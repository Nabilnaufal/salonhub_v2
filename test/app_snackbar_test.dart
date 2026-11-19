import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:salonhub_v2/app/widgets/app_snackbar.dart';

void main() {
  testWidgets('showAppSnack tampil di atas dengan latar putih', (tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () =>
                  showAppSnack('Profil diperbarui', 'Data berhasil disimpan.'),
              child: const Text('picu'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('picu'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Profil diperbarui'), findsOneWidget);
    expect(find.text('Data berhasil disimpan.'), findsOneWidget);

    final decoration = tester
        .widgetList<Container>(
          find.ancestor(
            of: find.text('Profil diperbarui'),
            matching: find.byType(Container),
          ),
        )
        .map((container) => container.decoration)
        .whereType<BoxDecoration>()
        .first;
    expect(decoration.color, Colors.white);

    // Kartu harus berada di separuh atas layar.
    expect(tester.getCenter(find.text('Profil diperbarui')).dy, lessThan(300));

    Get.closeAllSnackbars();
    await tester.pumpAndSettle();
  });
}
