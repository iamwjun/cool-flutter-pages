import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cool_pages/main.dart';

void main() {
  testWidgets('renders the feature gateway homepage', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const QuantumLoaderApp());

    expect(find.text('FEATURE GATEWAY'), findsOneWidget);
    expect(find.text('COOL FLUTTER PAGES'), findsOneWidget);
    expect(find.text('打开 System Status'), findsOneWidget);
    expect(find.text('打开 Detail'), findsOneWidget);
  });

  testWidgets('navigates to the system status page from the homepage', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const QuantumLoaderApp());

    final systemStatusButton = find.byKey(
      const ValueKey<String>('open-features-system_status'),
    );
    await tester.ensureVisible(systemStatusButton);
    await tester.tap(systemStatusButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('QUANTUM SYNC'), findsOneWidget);
  });

  testWidgets('navigates to the detail page from the homepage', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const QuantumLoaderApp());

    final detailButton = find.byKey(
      const ValueKey<String>('open-features-detail'),
    );
    await tester.ensureVisible(detailButton);
    await tester.tap(detailButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('DETAIL MODULE'), findsOneWidget);
    expect(find.text('建议下一步'), findsOneWidget);
  });
}
