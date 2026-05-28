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
    expect(find.text('打开 Journal Challenge'), findsOneWidget);
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

  testWidgets('navigates to the journal challenge page from the homepage', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const QuantumLoaderApp());

    final journalButton = find.byKey(
      const ValueKey<String>('open-features-journal_challenge'),
    );
    await tester.ensureVisible(journalButton);
    await tester.tap(journalButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('JOURNAL'), findsOneWidget);
    expect(find.text('Morning Walk'), findsOneWidget);

    final dailyTab = find.byKey(
      const ValueKey<String>('journal-challenge-tab-daily'),
    );
    await tester.ensureVisible(dailyTab);
    await tester.tap(dailyTab);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('DAILY GOAL'), findsOneWidget);
    expect(find.text('A simple way to\nstay healthy'), findsOneWidget);

    final profileTab = find.byKey(
      const ValueKey<String>('journal-challenge-tab-profile'),
    );
    await tester.ensureVisible(profileTab);
    await tester.tap(profileTab);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('PROFILE'), findsOneWidget);
    expect(find.text('Ron'), findsOneWidget);
    expect(find.text('Calories'), findsOneWidget);
  });
}
