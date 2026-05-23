import 'package:animal_island_flutter/animal_island_flutter.dart';
import 'package:animal_island_flutter_example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Finder docsSearchInput() {
    return find.descendant(
      of: find.byKey(const ValueKey('docs-search-box')),
      matching: find.byType(EditableText),
    );
  }

  Future<void> openDocs(WidgetTester tester) async {
    await tester.pumpWidget(const AnimalIslandDocsApp());
    await tester.pump();

    await tester.ensureVisible(find.text('开始使用 ->'));
    await tester.tap(find.text('开始使用 ->'));
    await tester.pump(const Duration(seconds: 2));
    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pump();
  }

  void setViewSize(WidgetTester tester, Size size) {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = size;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  }

  testWidgets('renders Flutter docs home page', (tester) async {
    await tester.pumpWidget(const AnimalIslandDocsApp());
    await tester.pump();

    expect(find.text('开始使用 ->'), findsOneWidget);
    expect(find.text('特性'), findsOneWidget);
  });

  testWidgets(
      'home navigation shows loading transition and fixed sidebar header',
      (tester) async {
    setViewSize(tester, const Size(1200, 900));
    await tester.pump();

    await tester.pumpWidget(const AnimalIslandDocsApp());
    await tester.pump();

    await tester.tap(find.text('开始使用 ->'));
    await tester.pump();

    expect(find.text('Button 按钮'), findsWidgets);
    expect(find.byType(AnimalLoading), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pump();

    expect(find.byType(AnimalLoading), findsNothing);
    expect(find.text('集合啦！Animal'), findsOneWidget);

    final sidebar = find.byWidgetPredicate(
      (widget) => widget.runtimeType.toString() == '_Sidebar',
    );
    final header = find.descendant(
      of: sidebar,
      matching: find.text('集合啦！Animal'),
    );
    final menuList = find.descendant(
      of: sidebar,
      matching: find.byType(ListView),
    );

    expect(header, findsOneWidget);
    expect(menuList, findsOneWidget);
    expect(
      find.descendant(of: menuList, matching: find.text('集合啦！Animal')),
      findsNothing,
    );
  });

  testWidgets('sidebar lists extended and advanced component pages',
      (tester) async {
    setViewSize(tester, const Size(1200, 900));
    await tester.pump();

    await openDocs(tester);

    expect(find.text('主题与基础'), findsOneWidget);
    expect(find.text('布局与容器'), findsOneWidget);
    expect(find.text('Radio 单选框'), findsOneWidget);
    expect(find.text('Tag 标签'), findsOneWidget);

    await tester.enterText(docsSearchInput(), 'theme');
    await tester.pump();
    expect(find.text('Theme 主题'), findsOneWidget);

    await tester.tap(find.text('Theme 主题'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Theme 主题定制'), findsWidgets);
    expect(find.text('主色切换（点击色块预览）'), findsOneWidget);
    expect(find.text('品牌主色派生卡片'), findsOneWidget);

    await tester.enterText(docsSearchInput(), 'skeleton');
    await tester.pump();
    expect(find.text('Skeleton 骨架屏'), findsWidgets);

    await tester.enterText(docsSearchInput(), 'form');
    await tester.pump();
    expect(find.text('Form 表单布局'), findsOneWidget);

    await tester.tap(find.text('Form 表单布局'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Form 表单布局'), findsWidgets);
    expect(find.text('horizontal 标签宽度'), findsWidgets);

    await tester.enterText(docsSearchInput(), 'timeline');
    await tester.pump();
    expect(find.text('Timeline 时间线'), findsWidgets);

    await tester.enterText(docsSearchInput(), 'mobile');
    await tester.pump();
    expect(find.text('MobileNavBar 导航栏'), findsWidgets);
    expect(find.text('BottomBar 底部栏'), findsWidgets);
    expect(find.text('ProductCard 商品卡片'), findsWidgets);
    expect(find.text('CouponCard 优惠券'), findsWidgets);

    await tester.enterText(docsSearchInput(), 'checkout');
    await tester.pump();
    expect(find.text('CheckoutBar 结算栏'), findsWidgets);

    await tester.enterText(docsSearchInput(), '地址');
    await tester.pump();
    expect(find.text('AddressCard 地址卡片'), findsWidgets);

    await tester.enterText(docsSearchInput(), 'cart');
    await tester.pump();
    expect(find.text('CartItem 购物车项'), findsWidgets);

    await tester.enterText(docsSearchInput(), 'payment');
    await tester.pump();
    expect(find.text('PaymentMethod 支付方式'), findsWidgets);
  });

  testWidgets('desktop docs sidebar supports global search', (tester) async {
    setViewSize(tester, const Size(1200, 900));
    await tester.pump();

    await openDocs(tester);

    expect(find.text('搜索组件 / API / 关键词'), findsOneWidget);

    await tester.enterText(docsSearchInput(), 'table');
    await tester.pump();

    final sidebar = find.byWidgetPredicate(
      (widget) => widget.runtimeType.toString() == '_Sidebar',
    );
    expect(
      find.descendant(of: sidebar, matching: find.text('Table 表格')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: sidebar, matching: find.text('Select 选择器')),
      findsNothing,
    );
  });

  testWidgets('mobile docs use compact top navigation and search',
      (tester) async {
    setViewSize(tester, const Size(390, 820));
    await tester.pump();

    await openDocs(tester);

    expect(find.text('Animal Docs'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) => widget.runtimeType.toString() == '_Sidebar',
      ),
      findsNothing,
    );
    expect(find.text('搜索组件 / API / 关键词'), findsOneWidget);

    await tester.enterText(docsSearchInput(), '上传');
    await tester.pump();

    expect(find.text('Upload 上传'), findsWidgets);

    await tester.enterText(docsSearchInput(), '优惠券');
    await tester.pump();
    expect(find.text('CouponCard 优惠券'), findsWidgets);
  });

  testWidgets('tablet width uses compact docs layout without overflow',
      (tester) async {
    setViewSize(tester, const Size(761, 910));
    await tester.pump();

    await openDocs(tester);

    expect(find.text('Animal Docs'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) => widget.runtimeType.toString() == '_Sidebar',
      ),
      findsNothing,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('desktop docs open phone simulator preview flow', (tester) async {
    setViewSize(tester, const Size(1200, 900));
    await tester.pump();

    await openDocs(tester);

    await tester.tap(find.text('手机预览'));
    await tester.pumpAndSettle();

    expect(find.text('手机模拟器预览'), findsOneWidget);
    expect(find.text('手机预览应用'), findsOneWidget);
    expect(
        find.textContaining('iframe 挂载独立 mobile_preview 应用'), findsOneWidget);
    expect(find.text('返回文档'), findsOneWidget);
  });
}
