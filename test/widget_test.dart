import 'package:SyncFly/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('应用可启动并显示演示按钮', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: VestibularCalmApp(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.textContaining('起飞流程演示'), findsOneWidget);
  });
}
