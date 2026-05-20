import 'package:animal_island_flutter/animal_island_flutter.dart';
import 'package:animal_island_flutter_example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders Flutter docs home page', (tester) async {
    await tester.pumpWidget(const AnimalIslandDocsApp());
    await tester.pump();

    expect(find.text('开始使用 ->'), findsOneWidget);
    expect(find.text('特性'), findsOneWidget);
  });

  testWidgets(
      'home navigation shows loading transition and fixed sidebar header',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

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
    await tester.binding.setSurfaceSize(const Size(1200, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const AnimalIslandDocsApp());
    await tester.pump();

    await tester.tap(find.text('开始使用 ->'));
    await tester.pump(const Duration(seconds: 2));
    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pump();

    expect(find.text('Radio 单选框'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Tag 标签'),
      160,
      scrollable: find.descendant(
        of: find.byWidgetPredicate(
          (widget) => widget.runtimeType.toString() == '_Sidebar',
        ),
        matching: find.byType(Scrollable),
      ),
    );
    expect(find.text('Tag 标签'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Alert 警告'),
      400,
      scrollable: find.descendant(
        of: find.byWidgetPredicate(
          (widget) => widget.runtimeType.toString() == '_Sidebar',
        ),
        matching: find.byType(Scrollable),
      ),
    );
    expect(find.text('Alert 警告'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Skeleton 骨架屏'),
      600,
      scrollable: find.descendant(
        of: find.byWidgetPredicate(
          (widget) => widget.runtimeType.toString() == '_Sidebar',
        ),
        matching: find.byType(Scrollable),
      ),
    );
    expect(find.text('Skeleton 骨架屏'), findsOneWidget);
  });
}
