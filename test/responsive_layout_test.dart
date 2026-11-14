import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project1/ui/widgets/common.dart';

/// Widths the app must support: small phones, large phones, tablets,
/// foldables, laptops and desktop windows.
const List<double> _widths = [320, 360, 390, 430, 600, 768, 1024, 1366, 1920];

Future<void> _pumpAt(
  WidgetTester tester,
  Size size,
  Widget child, {
  bool scroll = true,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: scroll ? SingleChildScrollView(child: child) : child,
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Widget _representativeContent() {
  return AppPage(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeader(
          title: 'Assignments',
          subtitle:
              'A long subtitle that must wrap instead of overflowing its '
              'parent on a narrow phone screen.',
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 7,
          runSpacing: 6,
          children: [
            StatusChip(
              label: 'Advanced Mathematics for Engineers and Scientists',
              maxWidth: 220,
            ),
            const StatusChip(label: 'Published'),
            const StatusChip(label: 'Due today · end of day'),
          ],
        ),
        const SizedBox(height: 10),
        AppFieldRow(
          children: [
            InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Starts',
                prefixIcon: Icon(Icons.schedule_outlined),
              ),
              child: const Text('9:00 AM'),
            ),
            InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Ends',
                prefixIcon: Icon(Icons.schedule_outlined),
              ),
              child: const Text('10:30 AM'),
            ),
          ],
        ),
        const SizedBox(height: 10),
        AppCard(
          child: Text(
            'Long user content ' * 40,
            style: const TextStyle(fontSize: 13),
          ),
        ),
      ],
    ),
  );
}

void main() {
  testWidgets('dialog body width never exceeds the viewport', (tester) async {
    double? measured;

    await _pumpAt(
      tester,
      const Size(320, 640),
      Builder(
        builder: (context) {
          measured = appDialogBodyWidth(context);
          return const SizedBox.shrink();
        },
      ),
    );
    expect(measured, 192);

    await _pumpAt(
      tester,
      const Size(1024, 768),
      Builder(
        builder: (context) {
          measured = appDialogBodyWidth(context);
          return const SizedBox.shrink();
        },
      ),
    );
    expect(measured, 500);

    await _pumpAt(
      tester,
      const Size(1024, 768),
      Builder(
        builder: (context) {
          measured = appDialogBodyWidth(context, max: 440);
          return const SizedBox.shrink();
        },
      ),
    );
    expect(measured, 440);
  });

  for (final width in _widths) {
    testWidgets('shared layout has no overflow at ${width.toInt()}px', (
      tester,
    ) async {
      await _pumpAt(
        tester,
        Size(width, width < 500 ? 700 : 900),
        _representativeContent(),
      );
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('paired form fields stack on small phones', (tester) async {
    await _pumpAt(tester, const Size(320, 700), _representativeContent());

    final starts = tester.getTopLeft(find.text('9:00 AM'));
    final ends = tester.getTopLeft(find.text('10:30 AM'));
    expect(ends.dy, greaterThan(starts.dy));
  });

  testWidgets('paired form fields sit side by side on wide screens', (
    tester,
  ) async {
    await _pumpAt(tester, const Size(1024, 900), _representativeContent());

    final starts = tester.getTopLeft(find.text('9:00 AM'));
    final ends = tester.getTopLeft(find.text('10:30 AM'));
    expect(ends.dy, starts.dy);
    expect(ends.dx, greaterThan(starts.dx));
  });

  testWidgets('confirm dialog fits a small screen and scrolls its content', (
    tester,
  ) async {
    await _pumpAt(
      tester,
      const Size(320, 480),
      Builder(
        builder: (context) => TextButton(
          onPressed: () => showConfirmDialog(
            context,
            title: 'Delete subject?',
            message: 'Deleting this subject cannot be undone. ' * 20,
            confirmLabel: 'Delete subject',
            destructive: true,
          ),
          child: const Text('Open dialog'),
        ),
      ),
    );

    await tester.tap(find.text('Open dialog'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Delete subject?'), findsOneWidget);
    expect(find.text('Delete subject'), findsOneWidget);
  });

  testWidgets('dialog actions stay visible above the on-screen keyboard', (
    tester,
  ) async {
    await _pumpAt(
      tester,
      const Size(360, 640),
      Builder(
        builder: (context) => TextButton(
          onPressed: () => showConfirmDialog(
            context,
            title: 'Delete subject?',
            message: 'Deleting this subject cannot be undone. ' * 20,
            confirmLabel: 'Delete subject',
            destructive: true,
          ),
          child: const Text('Open dialog'),
        ),
      ),
    );

    // Simulate a soft keyboard covering the bottom 280 logical pixels.
    tester.view.viewInsets = const FakeViewPadding(bottom: 280);
    addTearDown(tester.view.resetViewInsets);

    await tester.tap(find.text('Open dialog'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);

    final visibleBottom = 640 - 280;
    final confirm = tester.getBottomLeft(find.text('Delete subject'));
    final cancel = tester.getBottomLeft(find.text('Cancel'));
    expect(confirm.dy, lessThanOrEqualTo(visibleBottom));
    expect(cancel.dy, lessThanOrEqualTo(visibleBottom));
  });
}
