import 'package:animal_island_mobile_preview/main.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> scrollToMobileGroup(WidgetTester tester) async {
    await tester.scrollUntilVisible(
      find.text('移动端'),
      260,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
  }

  testWidgets('renders mobile preview categories', (tester) async {
    await tester.pumpWidget(const AnimalIslandMobilePreviewApp());
    await tester.pump();

    expect(find.text('组件分类'), findsWidgets);
    expect(find.text('主题与基础'), findsOneWidget);
    expect(find.text('表单输入'), findsOneWidget);
    await scrollToMobileGroup(tester);
    expect(find.text('移动端'), findsOneWidget);
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

  testWidgets('opens mobile component preview flow', (tester) async {
    await tester.pumpWidget(const AnimalIslandMobilePreviewApp());
    await tester.pump();

    await scrollToMobileGroup(tester);
    await tester.tap(find.text('移动端'));
    await tester.pumpAndSettle();

    expect(find.text('MobileNavBar 导航栏'), findsOneWidget);
    expect(find.text('ActionSheet 操作面板'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('ProductCard 商品卡片'),
      260,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('ProductCard 商品卡片'), findsOneWidget);
    expect(find.text('CouponCard 优惠券'), findsOneWidget);

    await tester.tap(find.text('CouponCard 优惠券'));
    await tester.pumpAndSettle();

    expect(find.text('优惠券卡片 — 支持可领取、已领取和已过期三种业务状态。'), findsOneWidget);
    expect(find.text('新人购物券'), findsOneWidget);
  });

  testWidgets('bottom navigation opens mobile business and feature sections',
      (tester) async {
    await tester.pumpWidget(const AnimalIslandMobilePreviewApp());
    await tester.pump();

    expect(find.text('分类'), findsWidgets);
    expect(find.text('移动'), findsOneWidget);
    expect(find.text('业务'), findsOneWidget);
    expect(find.text('特色'), findsOneWidget);

    await tester.tap(find.text('移动'));
    await tester.pumpAndSettle();

    expect(find.text('移动组件'), findsWidgets);
    expect(find.text('MobileNavBar 导航栏'), findsOneWidget);
    expect(find.text('ProductCard 商品卡片'), findsNothing);

    await tester.tap(find.text('业务'));
    await tester.pumpAndSettle();

    expect(find.text('移动业务'), findsWidgets);
    expect(find.text('ProductCard 商品卡片'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('CheckoutBar 结算栏'),
      260,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('CheckoutBar 结算栏'), findsOneWidget);

    await tester.tap(find.text('特色'));
    await tester.pumpAndSettle();

    expect(find.text('Animal 特色'), findsWidgets);
    expect(find.text('Phone 手机'), findsOneWidget);
  });
}
