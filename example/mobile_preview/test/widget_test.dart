import 'package:animal_island_mobile_preview/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders mobile preview categories', (tester) async {
    await tester.pumpWidget(const AnimalIslandMobilePreviewApp());
    await tester.pump();

    expect(find.text('组件分类'), findsWidgets);
    expect(find.text('主题与基础'), findsOneWidget);
    expect(find.text('表单输入'), findsOneWidget);
  });

  testWidgets('opens category list and component detail', (tester) async {
    await tester.pumpWidget(const AnimalIslandMobilePreviewApp());
    await tester.pump();

    await tester.tap(find.text('表单输入'));
    await tester.pumpAndSettle();

    expect(find.text('Select 选择器'), findsOneWidget);

    await tester.tap(find.text('Select 选择器'));
    await tester.pumpAndSettle();

    expect(find.text('下拉选择器组件 — 支持自定义选项列表，高亮当前选中项'), findsOneWidget);
  });
}
