import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Verifies that the dashboard images declared in `pubspec.yaml` resolve in
/// the asset bundle so the greeting header and role illustrations load.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('dashboard image assets are declared and loadable', () async {
    const images = [
      'asset/image/campus.jpg',
      'asset/image/student.jpg',
      'asset/image/teacher.jpg',
    ];

    for (final path in images) {
      final data = await rootBundle.load(path);
      expect(data, isA<ByteData>());
      expect(data.lengthInBytes, greaterThan(0), reason: '$path is empty');
    }
  });
}
