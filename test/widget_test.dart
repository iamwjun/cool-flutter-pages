import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('renders the quantum loading experience', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const QuantumLoaderApp());

    expect(find.text('SYSTEM STATUS'), findsOneWidget);
    expect(find.text('QUANTUM SYNC'), findsOneWidget);
    expect(find.text('正在校准粒子轨道、光束与界面着色器'), findsOneWidget);
    expect(find.text('SYNC'), findsOneWidget);
  });
}
