import 'dart:io';

import 'package:animal_island_flutter/animal_island_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('theme can derive a brand palette from primary color', () {
    final theme = AnimalThemeData.fromPrimary(const Color(0xFF4E8F75));

    expect(theme.primaryColor, const Color(0xFF4E8F75));
    expect(theme.primaryHoverColor, isNot(theme.primaryColor));
    expect(theme.primaryActiveColor, isNot(theme.primaryColor));
    expect(theme.primaryBackgroundColor, isNot(theme.primaryColor));
    expect(theme.fontPackage, 'animal_island_flutter');
  });

  test('theme copyWith can clear bundled font package', () {
    final theme = AnimalThemeData.fallback().copyWith(
      fontFamily: 'Inter',
      fontPackage: null,
      fontFamilyFallback: const ['Noto Sans SC', 'sans-serif'],
      textHeight: 1.4,
    );
    final style = theme.textStyle(height: 1.2);

    expect(theme.fontFamily, 'Inter');
    expect(theme.fontPackage, isNull);
    expect(theme.fontFamilyFallback, const ['Noto Sans SC', 'sans-serif']);
    expect(theme.textHeight, 1.4);
    expect(style.fontFamily, 'Inter');
    expect(style.height, 1.2);
  });

  test('theme keeps default accent tokens and derives custom ones', () {
    final fallback = AnimalThemeData.fallback();
    final branded = AnimalThemeData.fromPrimary(
      const Color(0xFF4E8F75),
      textColor: const Color(0xFF3F2B18),
    );

    expect(fallback.primarySolidColor, const Color(0xFF0CC0B5));
    expect(fallback.primaryStripeBackgroundColor, const Color(0xFF0EC4B6));
    expect(fallback.primaryStripeColor, const Color(0xFF01B0A7));
    expect(fallback.primaryStripeBorderColor, const Color(0xFF4DE2DA));
    expect(fallback.contentBackgroundColor, const Color(0xFFF7F3DF));
    expect(fallback.elevatedBackgroundColor, const Color(0xFFFFF8D6));
    expect(fallback.bodyTextColor, const Color(0xFF725D42));
    expect(branded.primarySolidColor, isNot(fallback.primarySolidColor));
    expect(
      branded.primaryStripeBackgroundColor,
      isNot(fallback.primaryStripeBackgroundColor),
    );
    expect(branded.bodyTextColor, isNot(fallback.bodyTextColor));
  });

  testWidgets('input and checkbox follow custom neutral theme tokens',
      (tester) async {
    final theme = AnimalThemeData.fallback().copyWith(
      backgroundColor: const Color(0xFFF4F1E7),
      textColor: const Color(0xFF3F2B18),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          data: theme,
          child: const Scaffold(
            body: Column(
              children: [
                AnimalInput(initialValue: 'Island'),
                AnimalCheckbox<String>(
                  value: [],
                  options: [
                    AnimalCheckboxOption(value: 'leaf', label: Text('Leaf')),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );

    expect(
      find.byWidgetPredicate(
        (widget) {
          final decoration =
              widget is AnimatedContainer ? widget.decoration : null;
          return decoration is BoxDecoration &&
              decoration.color == theme.contentBackgroundColor;
        },
      ),
      findsNWidgets(2),
    );

    final inputTextField = tester.widget<TextField>(find.byType(TextField));
    expect(inputTextField.style!.color, theme.bodyTextColor);
  });

  testWidgets('tabs active state follows custom theme primary accent',
      (tester) async {
    final theme = AnimalThemeData.fromPrimary(const Color(0xFF4E8F75));

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          data: theme,
          child: Scaffold(
            body: AnimalTabs(
              leafAnimation: false,
              shadow: false,
              items: const [
                AnimalTabItem(
                  key: 'one',
                  label: Text('One'),
                  child: Text('First content'),
                ),
                AnimalTabItem(
                  key: 'two',
                  label: Text('Two'),
                  child: Text('Second content'),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    final activeTab = tester.widget<AnimatedContainer>(
      find.byWidgetPredicate(
        (widget) {
          final decoration =
              widget is AnimatedContainer ? widget.decoration : null;
          return decoration is BoxDecoration &&
              decoration.color == theme.primarySolidColor;
        },
      ),
    );

    expect((activeTab.decoration! as BoxDecoration).color,
        theme.primarySolidColor);
  });

  testWidgets('table loading spinner follows custom theme primary color',
      (tester) async {
    final theme = AnimalThemeData.fromPrimary(const Color(0xFF4E8F75));

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          data: theme,
          child: Scaffold(
            body: AnimalTable<Map<String, String>>(
              loading: true,
              columns: [
                AnimalTableColumn(
                  title: const Text('Name'),
                  cellBuilder: (_, row, __) => Text(row['name']!),
                ),
              ],
              rows: const [
                {'name': 'Camera'},
              ],
            ),
          ),
        ),
      ),
    );

    final indicator = tester.widget<CircularProgressIndicator>(
      find.byType(CircularProgressIndicator),
    );

    expect(indicator.valueColor!.value, theme.primaryColor);
    expect(
        indicator.backgroundColor, theme.primaryColor.withValues(alpha: 0.18));
  });

  testWidgets('progress uses custom theme primary fill and text color',
      (tester) async {
    final theme = AnimalThemeData.fromPrimary(
      const Color(0xFF4E8F75),
      textColor: const Color(0xFF3F2B18),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          data: theme,
          child: const Scaffold(
            body: AnimalProgress(value: 0.4),
          ),
        ),
      ),
    );

    expect(
      find.byWidgetPredicate(
        (widget) {
          final decoration = widget is DecoratedBox ? widget.decoration : null;
          return decoration is BoxDecoration &&
              decoration.color == theme.primaryColor;
        },
      ),
      findsOneWidget,
    );

    final label = tester.widget<Text>(find.text('40%'));
    expect(label.style!.color, theme.textColor);
  });

  testWidgets('renders primary button', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: AnimalButton(
              type: AnimalButtonType.primary,
              child: Text('Go'),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Go'), findsOneWidget);
  });

  testWidgets('button loading shows striped text state without action',
      (tester) async {
    var taps = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: AnimalButton(
              type: AnimalButtonType.primary,
              loading: true,
              icon: const Icon(Icons.add),
              onPressed: () => taps += 1,
              child: const Text('Loading'),
            ),
          ),
        ),
      ),
    );

    await tester.pump(const Duration(milliseconds: 100));
    await tester.tap(find.byType(AnimalButton));
    await tester.pump();

    expect(find.text('Loading'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsNothing);
    expect(taps, 0);
  });

  testWidgets('button loading keeps animated stripe decoration',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: AnimalButton(
              type: AnimalButtonType.primary,
              loading: true,
              onPressed: () {},
              child: const Text('Loading'),
            ),
          ),
        ),
      ),
    );

    await tester.pump(const Duration(milliseconds: 120));

    final stripedBox = find.descendant(
      of: find.byType(AnimalButton),
      matching: find.byWidgetPredicate((widget) {
        final decoration = widget is DecoratedBox ? widget.decoration : null;
        return decoration.runtimeType
            .toString()
            .contains('ButtonLoadingStripeDecoration');
      }),
    );

    expect(stripedBox, findsOneWidget);
  });

  testWidgets('button can be activated from keyboard focus', (tester) async {
    var taps = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: AnimalButton(
              onPressed: () => taps += 1,
              child: const Text('Keyboard'),
            ),
          ),
        ),
      ),
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();

    expect(taps, 1);

    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pump();

    expect(taps, 2);
  });

  testWidgets('card can be activated from keyboard focus', (tester) async {
    var taps = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: AnimalCard(
              onTap: () => taps += 1,
              child: const Text('Interactive card'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Interactive card'));
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pumpAndSettle();

    expect(taps, 3);
  });

  testWidgets('clears input text', (tester) async {
    final controller = TextEditingController(text: 'Island');

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: AnimalInput(
              controller: controller,
              allowClear: true,
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('×'));
    await tester.pump();

    expect(controller.text, isEmpty);
  });

  testWidgets('input clear button supports keyboard activation',
      (tester) async {
    final controller = TextEditingController(text: 'Island');

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: AnimalInput(
              controller: controller,
              allowClear: true,
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('×'));
    controller.text = 'Again';
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();

    expect(controller.text, isEmpty);
  });

  testWidgets('multiline input uses textarea shape and top clear button',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: SizedBox(
              width: 320,
              child: AnimalInput(
                initialValue: '第一行\n第二行',
                allowClear: true,
                maxLines: 4,
              ),
            ),
          ),
        ),
      ),
    );

    final container = tester.widget<AnimatedContainer>(
      find.byType(AnimatedContainer).first,
    );
    final decoration = container.decoration! as BoxDecoration;
    final borderRadius = decoration.borderRadius! as BorderRadius;
    expect(borderRadius.topLeft.x, 24);

    final fieldTop = tester.getTopLeft(find.byType(TextField)).dy;
    final clearButton = find
        .ancestor(
          of: find.text('×'),
          matching: find.byType(AnimatedContainer),
        )
        .first;
    final clearTop = tester.getTopLeft(clearButton).dy;
    expect((clearTop - fieldTop).abs(), lessThanOrEqualTo(2));
  });

  testWidgets('input syncs updated initial value when uncontrolled',
      (tester) async {
    Widget buildInput(String value) {
      return MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: AnimalInput(initialValue: value),
          ),
        ),
      );
    }

    await tester.pumpWidget(buildInput('Island'));
    expect(find.text('Island'), findsOneWidget);

    await tester.pumpWidget(buildInput('Forest'));
    await tester.pump();

    expect(find.text('Forest'), findsOneWidget);
    expect(find.text('Island'), findsNothing);
  });

  testWidgets('input reports submitted value from keyboard action',
      (tester) async {
    var submitted = '';

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: AnimalInput(
              initialValue: 'Island',
              textInputAction: TextInputAction.done,
              onSubmitted: (value) => submitted = value,
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(TextField));
    await tester.pump();
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    expect(submitted, 'Island');
  });

  testWidgets('input form field validates saves and clears value',
      (tester) async {
    final formKey = GlobalKey<FormState>();
    var saved = '';
    var changed = '';
    var cleared = false;

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: Form(
              key: formKey,
              child: AnimalInputFormField(
                hintText: 'Name',
                allowClear: true,
                onChanged: (value) => changed = value,
                onClear: () => cleared = true,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Name required';
                  }
                  return null;
                },
                onSaved: (value) => saved = value ?? '',
              ),
            ),
          ),
        ),
      ),
    );

    expect(formKey.currentState!.validate(), isFalse);
    await tester.pump();
    expect(find.text('Name required'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Tom Nook');
    await tester.pump();
    expect(changed, 'Tom Nook');
    expect(formKey.currentState!.validate(), isTrue);
    formKey.currentState!.save();
    expect(saved, 'Tom Nook');

    await tester.tap(find.text('×'));
    await tester.pump();
    expect(cleared, isTrue);
    expect(changed, '');
    expect(formKey.currentState!.validate(), isFalse);
  });

  testWidgets('switch toggles controlled callback target', (tester) async {
    var checked = false;

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return AnimalSwitch(
                  value: checked,
                  checkedChild: const Text('ON'),
                  uncheckedChild: const Text('OFF'),
                  onChanged: (value) => setState(() => checked = value),
                );
              },
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(AnimalSwitch));
    await tester.pumpAndSettle();

    expect(checked, isTrue);
    expect(find.text('ON'), findsOneWidget);
  });

  testWidgets('switch handle keeps right-side border compensation',
      (tester) async {
    Widget buildSwitch({required bool value}) {
      return MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: Center(
              child: AnimalSwitch(
                value: value,
                onChanged: (_) {},
              ),
            ),
          ),
        ),
      );
    }

    await tester.pumpWidget(buildSwitch(value: false));

    AnimatedPositioned handlePosition() {
      return tester.widget<AnimatedPositioned>(
        find.descendant(
          of: find.byType(AnimalSwitch),
          matching: find.byType(AnimatedPositioned),
        ),
      );
    }

    await tester.pumpWidget(buildSwitch(value: true));
    await tester.pumpAndSettle();

    final checkedLeft = handlePosition().left!;
    const width = 52.0;
    const handleSize = 21.0;
    const borderWidth = 2.5;
    const handleInset = 2.0;
    final rawRightInset = width - checkedLeft - handleSize;
    final visualRightInset = rawRightInset - borderWidth * 2;

    expect(visualRightInset, handleInset);
  });

  testWidgets('switch supports keyboard activation and focus affordance',
      (tester) async {
    final theme = AnimalThemeData.fallback();
    var checked = false;

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          data: theme,
          child: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return AnimalSwitch(
                  value: checked,
                  onChanged: (value) => setState(() => checked = value),
                );
              },
            ),
          ),
        ),
      ),
    );

    BoxDecoration switchDecoration() {
      final decorated = find.byWidgetPredicate((widget) {
        final decoration =
            widget is AnimatedContainer ? widget.decoration : null;
        return decoration is BoxDecoration &&
            decoration.borderRadius == BorderRadius.circular(50);
      });
      final container = tester.widget<AnimatedContainer>(decorated.first);
      return container.decoration! as BoxDecoration;
    }

    await tester.tap(find.byType(AnimalSwitch));
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pumpAndSettle();

    expect(checked, isTrue);

    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer();
    await gesture.moveTo(tester.getCenter(find.byType(AnimalSwitch)));
    await tester.pumpAndSettle();

    expect(
      (switchDecoration().border! as Border).top.color,
      const Color(0xFF5A9E1E),
    );

    await gesture.removePointer();
  });

  testWidgets('switch exposes toggled semantics for assistive technologies',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: AnimalSwitch(
              value: true,
              onChanged: (_) {},
            ),
          ),
        ),
      ),
    );

    final semantics = find
        .descendant(
          of: find.byType(AnimalSwitch),
          matching: find.byType(Semantics),
        )
        .evaluate()
        .map((element) => element.widget)
        .whereType<Semantics>()
        .firstWhere((widget) => widget.properties.toggled == true);

    expect(semantics.properties.button, isTrue);
    expect(semantics.properties.enabled, isTrue);
    expect(semantics.properties.toggled, isTrue);
  });

  testWidgets('select opens overlay and reports selected option',
      (tester) async {
    var selected = 'forest';

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return Center(
                  child: AnimalSelect<String>(
                    value: selected,
                    options: const [
                      AnimalSelectOption(key: 'forest', label: '森林'),
                      AnimalSelectOption(key: 'beach', label: '海滩'),
                    ],
                    onChanged: (value) => setState(() => selected = value),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(AnimalSelect<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('海滩').last);
    await tester.pumpAndSettle();

    expect(selected, 'beach');
  });

  testWidgets('select closes overlay when disabled externally', (tester) async {
    Widget buildSelect({required bool disabled}) {
      return MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: AnimalSelect<String>(
              value: 'forest',
              disabled: disabled,
              options: const [
                AnimalSelectOption(key: 'forest', label: '森林'),
                AnimalSelectOption(key: 'beach', label: '海滩'),
              ],
              onChanged: (_) {},
            ),
          ),
        ),
      );
    }

    await tester.pumpWidget(buildSelect(disabled: false));

    await tester.tap(find.byType(AnimalSelect<String>));
    await tester.pumpAndSettle();
    expect(find.text('海滩'), findsOneWidget);

    await tester.pumpWidget(buildSelect(disabled: true));
    await tester.pumpAndSettle();

    expect(find.text('海滩'), findsNothing);
  });

  testWidgets('select hover renders animal cursor affordance', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: Center(
              child: AnimalSelect<String>(
                value: 'forest',
                options: const [
                  AnimalSelectOption(key: 'forest', label: '森林'),
                  AnimalSelectOption(key: 'beach', label: '海滩'),
                ],
                onChanged: (_) {},
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(AnimalSelect<String>));
    await tester.pumpAndSettle();

    final optionCenter = tester.getCenter(find.text('海滩').last);
    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer(location: optionCenter);
    addTearDown(gesture.removePointer);
    await tester.pump();
    await gesture.moveTo(optionCenter);
    await tester.pump(const Duration(milliseconds: 100));

    expect(
      find.image(
        const AssetImage(
          'assets/animal_island/img/cursor/select-cursor.png',
          package: 'animal_island_flutter',
        ),
      ),
      findsOneWidget,
    );
  });

  testWidgets('select dropdown constrains height and scrolls long options',
      (tester) async {
    String? selected = 'item0';
    final options = [
      for (var index = 0; index < 16; index++)
        AnimalSelectOption(key: 'item$index', label: '选项$index'),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return Center(
                  child: AnimalSelect<String>(
                    value: selected,
                    dropdownMaxHeight: 150,
                    options: options,
                    onChanged: (value) => setState(() => selected = value),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(AnimalSelect<String>));
    await tester.pumpAndSettle();

    final scrollable = find.descendant(
      of: find.byType(Overlay),
      matching: find.byType(Scrollable),
    );
    expect(scrollable, findsOneWidget);
    expect(tester.getSize(scrollable).height, lessThanOrEqualTo(150));

    await tester.scrollUntilVisible(
      find.text('选项15'),
      80,
      scrollable: scrollable,
    );
    await tester.tap(find.text('选项15'));
    await tester.pumpAndSettle();

    expect(selected, 'item15');
  });

  testWidgets('select dropdown keeps selected state marker', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: Center(
              child: AnimalSelect<String>(
                value: 'forest',
                options: const [
                  AnimalSelectOption(key: 'forest', label: '森林'),
                  AnimalSelectOption(key: 'beach', label: '海滩'),
                ],
                onChanged: (_) {},
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(AnimalSelect<String>));
    await tester.pumpAndSettle();

    final selectedLabel = tester.widget<Text>(find.text('森林').last);

    expect(selectedLabel.style!.fontWeight, FontWeight.w800);
  });

  testWidgets('select can be opened and selected from keyboard',
      (tester) async {
    var selected = 'forest';

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return AnimalSelect<String>(
                  value: selected,
                  options: const [
                    AnimalSelectOption(key: 'forest', label: '森林'),
                    AnimalSelectOption(key: 'beach', label: '海滩'),
                    AnimalSelectOption(key: 'camp', label: '露营地'),
                  ],
                  onChanged: (value) => setState(() => selected = value),
                );
              },
            ),
          ),
        ),
      ),
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pumpAndSettle();
    expect(find.text('海滩'), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();

    expect(selected, 'beach');
    expect(find.text('露营地'), findsNothing);
  });

  testWidgets('select closes keyboard overlay with escape', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: AnimalSelect<String>(
              value: 'forest',
              options: const [
                AnimalSelectOption(key: 'forest', label: '森林'),
                AnimalSelectOption(key: 'beach', label: '海滩'),
              ],
              onChanged: (_) {},
            ),
          ),
        ),
      ),
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(find.text('海滩'), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();

    expect(find.text('海滩'), findsNothing);
  });

  testWidgets('select form field validates and saves selected value',
      (tester) async {
    final formKey = GlobalKey<FormState>();
    var saved = '';

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: Form(
              key: formKey,
              child: AnimalSelectFormField<String>(
                value: null,
                placeholder: '选择地点',
                options: const [
                  AnimalSelectOption(key: 'forest', label: '森林'),
                  AnimalSelectOption(key: 'beach', label: '海滩'),
                ],
                onChanged: (_) {},
                validator: (value) => value == null ? '请选择地点' : null,
                onSaved: (value) => saved = value ?? '',
              ),
            ),
          ),
        ),
      ),
    );

    expect(formKey.currentState!.validate(), isFalse);
    await tester.pump();
    expect(find.text('请选择地点'), findsOneWidget);

    await tester.tap(find.byType(AnimalSelect<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('海滩').last);
    await tester.pumpAndSettle();

    expect(formKey.currentState!.validate(), isTrue);
    formKey.currentState!.save();
    expect(saved, 'beach');
  });

  testWidgets('checkbox radio switch slider and rate form fields save',
      (tester) async {
    final formKey = GlobalKey<FormState>();
    List<String> savedCheckbox = const [];
    String? savedRadio;
    var savedSwitch = false;
    var savedSlider = 0.0;
    var savedRate = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: Form(
              key: formKey,
              child: Column(
                children: [
                  AnimalCheckboxFormField<String>(
                    value: const [],
                    options: const [
                      AnimalCheckboxOption(
                          value: 'apple', label: Text('Apple')),
                    ],
                    onSaved: (value) => savedCheckbox = value ?? const [],
                  ),
                  AnimalRadioFormField<String>(
                    options: const [
                      AnimalRadioOption(value: 'a', label: Text('A')),
                      AnimalRadioOption(value: 'b', label: Text('B')),
                    ],
                    validator: (value) => value == null ? '请选择' : null,
                    onSaved: (value) => savedRadio = value,
                  ),
                  AnimalSwitchFormField(
                    defaultValue: false,
                    onSaved: (value) => savedSwitch = value ?? false,
                  ),
                  AnimalSliderFormField(
                    defaultValue: 20,
                    divisions: 10,
                    onSaved: (value) => savedSlider = value ?? 0,
                  ),
                  AnimalRateFormField(
                    defaultValue: 2,
                    onSaved: (value) => savedRate = value ?? 0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    expect(formKey.currentState!.validate(), isFalse);
    await tester.tap(find.text('Apple'));
    await tester.pump();
    await tester.tap(find.text('B'));
    await tester.pump();
    await tester.tap(find.byType(AnimalSwitch));
    await tester.pumpAndSettle();
    final sliderRect = tester.getRect(find.byType(AnimalSlider));
    await tester.tapAt(
      Offset(sliderRect.left + sliderRect.width * 0.30, sliderRect.center.dy),
    );
    await tester.pump();
    await tester.tap(find.byIcon(Icons.star_rounded).at(3));
    await tester.pump();

    expect(formKey.currentState!.validate(), isTrue);
    formKey.currentState!.save();

    expect(savedCheckbox, ['apple']);
    expect(savedRadio, 'b');
    expect(savedSwitch, isTrue);
    expect(savedSlider, 30);
    expect(savedRate, 4);
  });

  testWidgets('tabs can be controlled and emit changes', (tester) async {
    var active = 'one';
    var changed = '';

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return AnimalTabs(
                  activeKey: active,
                  leafAnimation: false,
                  shadow: false,
                  onChanged: (key) {
                    changed = key;
                    setState(() => active = key);
                  },
                  items: const [
                    AnimalTabItem(
                      key: 'one',
                      label: Text('One'),
                      child: Text('First content'),
                    ),
                    AnimalTabItem(
                      key: 'two',
                      label: Text('Two'),
                      child: Text('Second content'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Two'));
    await tester.pumpAndSettle();

    expect(changed, 'two');
    expect(find.text('Second content'), findsOneWidget);
    expect(find.text('First content'), findsNothing);
  });

  testWidgets('tabs can move selection with arrow keys', (tester) async {
    var active = 'one';

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return AnimalTabs(
                  activeKey: active,
                  leafAnimation: false,
                  shadow: false,
                  onChanged: (key) => setState(() => active = key),
                  items: const [
                    AnimalTabItem(
                      key: 'one',
                      label: Text('One'),
                      child: Text('First content'),
                    ),
                    AnimalTabItem(
                      key: 'two',
                      label: Text('Two'),
                      child: Text('Second content'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pumpAndSettle();

    expect(active, 'two');
    expect(find.text('Second content'), findsOneWidget);
  });

  testWidgets('checkbox ignores disabled options', (tester) async {
    var values = <String>[];

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: AnimalCheckbox<String>(
              value: values,
              options: const [
                AnimalCheckboxOption(value: 'open', label: Text('Open')),
                AnimalCheckboxOption(
                  value: 'locked',
                  label: Text('Locked'),
                  disabled: true,
                ),
              ],
              onChanged: (next) => values = next,
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Locked'));
    await tester.pump();

    expect(values, isEmpty);
  });

  testWidgets('checkbox can toggle focused option from keyboard',
      (tester) async {
    var values = <String>[];

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return AnimalCheckbox<String>(
                  value: values,
                  options: const [
                    AnimalCheckboxOption(value: 'open', label: Text('Open')),
                    AnimalCheckboxOption(
                      value: 'locked',
                      label: Text('Locked'),
                      disabled: true,
                    ),
                  ],
                  onChanged: (next) => setState(() => values = next),
                );
              },
            ),
          ),
        ),
      ),
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pump();

    expect(values, ['open']);

    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pump();

    expect(values, isEmpty);
  });

  testWidgets('table can hide header and handle row tap', (tester) async {
    var tapped = '';

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: AnimalTable<Map<String, String>>(
              showHeader: false,
              onRowTap: (row, index) => tapped = '${row['name']}-$index',
              columns: [
                AnimalTableColumn(
                  title: const Text('Name'),
                  cellBuilder: (_, row, __) => Text(row['name']!),
                ),
              ],
              rows: const [
                {'name': 'Camera'},
              ],
            ),
          ),
        ),
      ),
    );

    expect(find.text('Name'), findsNothing);
    await tester.tap(find.text('Camera'));
    expect(tapped, 'Camera-0');
  });

  testWidgets('table row can be activated from keyboard focus', (tester) async {
    var tapped = '';

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: AnimalTable<Map<String, String>>(
              onRowTap: (row, index) => tapped = '${row['name']}-$index',
              columns: [
                AnimalTableColumn(
                  title: const Text('Name'),
                  cellBuilder: (_, row, __) => Text(row['name']!),
                ),
              ],
              rows: const [
                {'name': 'Camera'},
              ],
            ),
          ),
        ),
      ),
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();

    expect(tapped, 'Camera-0');
  });

  testWidgets('table can scroll horizontally to reveal overflow columns',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: SizedBox(
              width: 280,
              child: AnimalTable<Map<String, String>>(
                columns: [
                  AnimalTableColumn(
                    title: const Text('Name'),
                    width: 180,
                    cellBuilder: (_, row, __) => Text(row['name']!),
                  ),
                  AnimalTableColumn(
                    title: const Text('Island'),
                    width: 180,
                    cellBuilder: (_, row, __) => Text(row['island']!),
                  ),
                  AnimalTableColumn(
                    title: const Text('Fruit'),
                    width: 180,
                    cellBuilder: (_, row, __) => Text(row['fruit']!),
                  ),
                ],
                rows: const [
                  {
                    'name': 'Molly',
                    'island': 'Starfall',
                    'fruit': 'Peach',
                  },
                ],
              ),
            ),
          ),
        ),
      ),
    );

    expect(tester.getTopLeft(find.text('Fruit')).dx, greaterThan(280));

    await tester.drag(
        find.byType(AnimalTable<Map<String, String>>), const Offset(-360, 0));
    await tester.pumpAndSettle();

    expect(tester.getTopLeft(find.text('Fruit')).dx, lessThan(280));
    expect(find.byType(Scrollbar), findsOneWidget);
  });

  testWidgets('radio emits one selected value', (tester) async {
    var selected = 'beach';

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return AnimalRadio<String>(
                  value: selected,
                  options: const [
                    AnimalRadioOption(value: 'beach', label: Text('Beach')),
                    AnimalRadioOption(value: 'forest', label: Text('Forest')),
                  ],
                  onChanged: (value) => setState(() => selected = value),
                );
              },
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Forest'));
    await tester.pump();

    expect(selected, 'forest');
  });

  testWidgets('radio can select focused option from keyboard', (tester) async {
    var selected = 'beach';

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return AnimalRadio<String>(
                  value: selected,
                  options: const [
                    AnimalRadioOption(
                      value: 'beach',
                      label: Text('Beach'),
                      disabled: true,
                    ),
                    AnimalRadioOption(value: 'forest', label: Text('Forest')),
                  ],
                  onChanged: (value) => setState(() => selected = value),
                );
              },
            ),
          ),
        ),
      ),
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();

    expect(selected, 'forest');
  });

  testWidgets('pagination reports requested page', (tester) async {
    var page = 1;

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return AnimalPagination(
                  current: page,
                  total: 80,
                  onChanged: (value) => setState(() => page = value),
                );
              },
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('2'));
    await tester.pump();

    expect(page, 2);
  });

  testWidgets('pagination buttons can be activated from keyboard focus',
      (tester) async {
    var page = 1;

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return AnimalPagination(
                  current: page,
                  total: 80,
                  onChanged: (value) => setState(() => page = value),
                );
              },
            ),
          ),
        ),
      ),
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pump();

    expect(page, 2);
  });

  testWidgets('disabled pagination ignores keyboard activation',
      (tester) async {
    var page = 1;

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: AnimalPagination(
              current: page,
              total: 80,
              disabled: true,
              onChanged: (value) => page = value,
            ),
          ),
        ),
      ),
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pump();

    expect(page, 1);
  });

  testWidgets('badge hides zero unless showZero is true', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: Column(
              children: [
                AnimalBadge(count: 0, child: Text('Hidden')),
                AnimalBadge(count: 0, showZero: true, child: Text('Shown')),
              ],
            ),
          ),
        ),
      ),
    );

    expect(find.text('0'), findsOneWidget);
  });

  testWidgets('tooltip can render in a configured placement', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: Center(
              child: AnimalTooltip(
                message: 'Right side',
                placement: AnimalTooltipPlacement.right,
                waitDuration: Duration.zero,
                child: Text('Hover me'),
              ),
            ),
          ),
        ),
      ),
    );

    final gesture =
        await tester.startGesture(tester.getCenter(find.text('Hover me')));
    await tester.pump(kLongPressTimeout);

    expect(find.text('Right side'), findsOneWidget);
    final bubble = find.ancestor(
      of: find.text('Right side'),
      matching: find.byWidgetPredicate(
        (widget) => widget is Container && widget.decoration is BoxDecoration,
      ),
    );
    expect(bubble, findsOneWidget);
    expect(tester.getSize(bubble).width, lessThan(300));
    expect(tester.getSize(bubble).height, lessThan(80));

    await gesture.up();
  });

  testWidgets('tooltip updates visible message while open', (tester) async {
    var message = 'First';

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    AnimalTooltip(
                      message: message,
                      waitDuration: Duration.zero,
                      showDuration: const Duration(seconds: 30),
                      child: const Text('Hover target'),
                    ),
                    AnimalButton(
                      onPressed: () => setState(() => message = 'Second'),
                      child: const Text('Update tooltip'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );

    final gesture =
        await tester.startGesture(tester.getCenter(find.text('Hover target')));
    await tester.pump(kLongPressTimeout);

    expect(find.text('First'), findsOneWidget);

    await tester.tap(find.text('Update tooltip'));
    await tester.pump();
    await tester.pump();

    expect(find.text('Second'), findsOneWidget);
    expect(find.text('First'), findsNothing);

    await gesture.up();
  });

  testWidgets('collapse supports keyboard activation and hover affordance',
      (tester) async {
    final theme = AnimalThemeData.fallback();

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          data: theme,
          child: const Scaffold(
            body: AnimalCollapse(
              question: Text('如何到达岛屿？'),
              answer: Text('从码头出发。'),
            ),
          ),
        ),
      ),
    );

    BoxDecoration collapseDecoration() {
      final decorated = find.byWidgetPredicate((widget) {
        final decoration =
            widget is AnimatedContainer ? widget.decoration : null;
        return decoration is BoxDecoration &&
            decoration.borderRadius == BorderRadius.circular(theme.radius);
      });
      final container = tester.widget<AnimatedContainer>(decorated.first);
      return container.decoration! as BoxDecoration;
    }

    await tester.tap(find.text('如何到达岛屿？'));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<AnimatedCrossFade>(find.byType(AnimatedCrossFade))
          .crossFadeState,
      CrossFadeState.showSecond,
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<AnimatedCrossFade>(find.byType(AnimatedCrossFade))
          .crossFadeState,
      CrossFadeState.showFirst,
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<AnimatedCrossFade>(find.byType(AnimatedCrossFade))
          .crossFadeState,
      CrossFadeState.showSecond,
    );

    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer();
    await gesture.moveTo(tester.getCenter(find.text('如何到达岛屿？')));
    await tester.pumpAndSettle();

    expect(
      (collapseDecoration().border! as Border).top.color,
      theme.primaryColor,
    );

    await gesture.removePointer();
  });

  testWidgets('breadcrumb items support keyboard activation and disabled state',
      (tester) async {
    var taps = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: AnimalBreadcrumb(
              items: [
                AnimalBreadcrumbItem(
                  label: const Text('首页'),
                  onTap: () => taps += 1,
                ),
                AnimalBreadcrumbItem(
                  label: const Text('禁用'),
                  disabled: true,
                  onTap: () => taps += 10,
                ),
                const AnimalBreadcrumbItem(label: Text('详情')),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('首页'));
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pumpAndSettle();
    expect(taps, 3);

    await tester.tap(find.text('禁用'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('详情'));
    await tester.pumpAndSettle();
    expect(taps, 3);
  });

  testWidgets('message overlay appears and then dismisses', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Builder(
            builder: (context) {
              return Scaffold(
                body: AnimalButton(
                  onPressed: () => AnimalMessage.success(
                    context,
                    const Text('Saved'),
                    duration: const Duration(milliseconds: 250),
                  ),
                  child: const Text('Show'),
                ),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Show'));
    await tester.pump();

    expect(find.text('Saved'), findsOneWidget);

    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(find.text('Saved'), findsNothing);
  });

  testWidgets('message can be manually removed before timeout', (tester) async {
    OverlayEntry? entry;

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Builder(
            builder: (context) {
              return Scaffold(
                body: Column(
                  children: [
                    AnimalButton(
                      onPressed: () {
                        entry = AnimalMessage.info(
                          context,
                          const Text('Temporary'),
                          duration: const Duration(milliseconds: 250),
                        );
                      },
                      child: const Text('Show temporary'),
                    ),
                    AnimalButton(
                      onPressed: () => entry?.remove(),
                      child: const Text('Remove temporary'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Show temporary'));
    await tester.pump();
    expect(find.text('Temporary'), findsOneWidget);

    entry?.remove();
    await tester.pump();
    expect(find.text('Temporary'), findsNothing);

    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('dialog can be dismissed with escape key', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Builder(
            builder: (context) {
              return Scaffold(
                body: AnimalButton(
                  onPressed: () => AnimalDialog.show<void>(
                    context: context,
                    title: const Text('Notice'),
                    child: const Text('Dialog body'),
                    typewriter: false,
                  ),
                  child: const Text('Open dialog'),
                ),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open dialog'));
    await tester.pumpAndSettle();
    expect(find.text('Dialog body'), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();

    expect(find.text('Dialog body'), findsNothing);
  });

  testWidgets('dialog keeps organic clip and border painters', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: Center(
              child: AnimalDialog(
                title: Text('Notice'),
                typewriter: false,
                child: Text('Dialog body'),
              ),
            ),
          ),
        ),
      ),
    );

    final customPaint = find
        .descendant(
          of: find.byType(AnimalDialog),
          matching: find.byType(CustomPaint),
        )
        .evaluate()
        .map((element) => element.widget)
        .whereType<CustomPaint>()
        .firstWhere((widget) {
      return widget.painter != null && widget.foregroundPainter != null;
    });

    expect(customPaint.painter, isNotNull);
    expect(customPaint.foregroundPainter, isNotNull);
    expect(
      find.descendant(
        of: find.byType(AnimalDialog),
        matching: find.byType(ClipPath),
      ),
      findsOneWidget,
    );
  });

  testWidgets('alert can close itself', (tester) async {
    var closed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: AnimalAlert(
              title: const Text('Notice'),
              closable: true,
              onClose: () => closed = true,
              child: const Text('Island updated'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pump();

    expect(closed, isTrue);
    expect(find.text('Island updated'), findsNothing);
  });

  testWidgets('alert and tag close buttons support keyboard activation',
      (tester) async {
    var alertClosed = false;
    var tagClosed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: Column(
              children: [
                AnimalAlert(
                  closable: true,
                  onClose: () => alertClosed = true,
                  child: const Text('Keyboard alert'),
                ),
                AnimalTag(
                  closable: true,
                  onClose: () => tagClosed = true,
                  child: const Text('Keyboard tag'),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pump();
    expect(alertClosed, isTrue);

    await tester.tap(find.text('×'));
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(tagClosed, isTrue);
  });

  testWidgets('segmented emits selected option', (tester) async {
    var value = 'list';

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return AnimalSegmented<String>(
                  value: value,
                  options: const [
                    AnimalSegmentedOption(value: 'list', label: Text('List')),
                    AnimalSegmentedOption(value: 'grid', label: Text('Grid')),
                  ],
                  onChanged: (next) => setState(() => value = next),
                );
              },
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Grid'));
    await tester.pump();

    expect(value, 'grid');
  });

  testWidgets('segmented can select focused option from keyboard',
      (tester) async {
    var value = 'list';

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return AnimalSegmented<String>(
                  value: value,
                  options: const [
                    AnimalSegmentedOption(
                      value: 'list',
                      label: Text('List'),
                      disabled: true,
                    ),
                    AnimalSegmentedOption(value: 'grid', label: Text('Grid')),
                  ],
                  onChanged: (next) => setState(() => value = next),
                );
              },
            ),
          ),
        ),
      ),
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();

    expect(value, 'grid');
  });

  testWidgets('rate emits selected score', (tester) async {
    var score = 2;

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return AnimalRate(
                  value: score,
                  onChanged: (next) => setState(() => score = next),
                );
              },
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.star_rounded).at(3));
    await tester.pump();

    expect(score, 4);
  });

  testWidgets('rate can be adjusted from keyboard focus', (tester) async {
    var score = 2;

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return AnimalRate(
                  value: score,
                  onChanged: (next) => setState(() => score = next),
                );
              },
            ),
          ),
        ),
      ),
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pump();
    expect(score, 3);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await tester.pump();
    expect(score, 2);
  });

  testWidgets('disabled rate ignores keyboard adjustment', (tester) async {
    var score = 2;

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: AnimalRate(
              value: score,
              disabled: true,
              onChanged: (next) => score = next,
            ),
          ),
        ),
      ),
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pump();

    expect(score, 2);
  });

  testWidgets('slider can be adjusted from keyboard focus', (tester) async {
    var value = 20.0;

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return AnimalSlider(
                  value: value,
                  divisions: 10,
                  onChanged: (next) => setState(() => value = next),
                );
              },
            ),
          ),
        ),
      ),
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pump();
    expect(value, 30);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await tester.pump();
    expect(value, 20);
  });

  testWidgets('slider handle stays inside the track at endpoints',
      (tester) async {
    Widget buildSlider(double value) {
      return MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: SizedBox(
              width: 200,
              child: AnimalSlider(
                value: value,
                showLabel: false,
                onChanged: (_) {},
              ),
            ),
          ),
        ),
      );
    }

    Positioned handlePosition() {
      return tester.widget<Positioned>(
        find.descendant(
          of: find.byType(AnimalSlider),
          matching: find.byType(Positioned),
        ),
      );
    }

    await tester.pumpWidget(buildSlider(0));
    expect(handlePosition().left, 0);
    expect(
      find.descendant(
        of: find.byType(AnimalSlider),
        matching: find.byType(FractionallySizedBox),
      ),
      findsNothing,
    );

    await tester.pumpWidget(buildSlider(100));
    await tester.pumpAndSettle();
    expect(handlePosition().left, 176);
  });

  testWidgets('disabled slider ignores keyboard adjustment', (tester) async {
    var value = 20.0;

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: AnimalSlider(
              value: value,
              disabled: true,
              onChanged: (next) => value = next,
            ),
          ),
        ),
      ),
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pump();

    expect(value, 20);
  });

  testWidgets('steps reports selected index', (tester) async {
    var current = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return AnimalSteps(
                  current: current,
                  onChanged: (index) => setState(() => current = index),
                  items: const [
                    AnimalStepItem(title: Text('Start')),
                    AnimalStepItem(title: Text('Pack')),
                    AnimalStepItem(title: Text('Arrive')),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Pack'));
    await tester.pump();

    expect(current, 1);
  });

  testWidgets('skeleton reveals child when inactive', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: AnimalSkeleton(
              active: false,
              child: Text('Loaded'),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Loaded'), findsOneWidget);
  });

  testWidgets('form item renders label help and horizontal layout',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: AnimalForm(
              layout: AnimalFormLayout.horizontal,
              child: AnimalFormItem(
                label: Text('昵称'),
                required: true,
                help: Text('显示在岛民名片上'),
                child: AnimalInput(initialValue: '豆狸'),
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('昵称'), findsOneWidget);
    expect(find.text('*'), findsOneWidget);
    expect(find.text('显示在岛民名片上'), findsOneWidget);
    expect(find.text('豆狸'), findsOneWidget);
  });

  testWidgets('search and number inputs emit values', (tester) async {
    var searched = '';
    num number = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: Column(
              children: [
                AnimalSearchInput(onSearch: (value) => searched = value),
                AnimalNumberInput(
                  defaultValue: 2,
                  min: 0,
                  max: 5,
                  onChanged: (value) => number = value,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField).first, 'leaf');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pump();
    expect(searched, 'leaf');

    await tester.enterText(find.byType(TextField).first, 'flower');
    await tester.pump();
    await tester.tap(find.byIcon(Icons.arrow_forward_rounded));
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(searched, 'flower');

    await tester.tap(find.byIcon(Icons.keyboard_arrow_up_rounded));
    await tester.pump();
    expect(number, 3);

    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pump();
    expect(number, 4);

    await tester.tap(find.byIcon(Icons.keyboard_arrow_down_rounded));
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(number, 2);
  });

  testWidgets('password input toggles obscure text', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: AnimalPasswordInput(initialValue: 'secret'),
          ),
        ),
      ),
    );

    TextField field() => tester.widget<TextField>(find.byType(TextField));

    expect(field().obscureText, isTrue);
    await tester.tap(find.byIcon(Icons.visibility_rounded));
    await tester.pump();
    expect(field().obscureText, isFalse);
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pump();
    expect(field().obscureText, isTrue);
  });

  testWidgets('dropdown opens and selects enabled item', (tester) async {
    var selected = '';

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: AnimalDropdown<String>(
              items: const [
                AnimalDropdownItem(value: 'copy', label: Text('复制')),
                AnimalDropdownItem(
                  value: 'delete',
                  label: Text('删除'),
                  disabled: true,
                ),
              ],
              onChanged: (value) => selected = value,
              child: const AnimalButton(child: Text('菜单')),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('菜单'));
    await tester.pump();
    await tester.pump();
    expect(find.text('复制'), findsOneWidget);
    final dropdownPanel = find.byWidgetPredicate(
      (widget) =>
          widget is SizedBox &&
          widget.width == 220 &&
          widget.child.runtimeType.toString() == '_PopoverPanel',
    );
    expect(dropdownPanel, findsOneWidget);
    expect(tester.getSize(dropdownPanel).width, 220);

    await tester.tap(find.text('复制'));
    await tester.pump();
    await tester.pump();
    expect(selected, 'copy');
    expect(find.text('复制'), findsNothing);
  });

  testWidgets('dropdown menu supports keyboard activation and escape',
      (tester) async {
    var selected = '';

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: AnimalDropdown<String>(
              items: const [
                AnimalDropdownItem(value: 'copy', label: Text('复制')),
                AnimalDropdownItem(value: 'share', label: Text('分享')),
              ],
              onChanged: (value) => selected = value,
              child: const AnimalButton(child: Text('更多')),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('更多'));
    await tester.pump();
    await tester.pump();
    expect(find.text('复制'), findsOneWidget);

    await tester.tap(find.text('复制'));
    await tester.pump();
    await tester.pump();
    expect(selected, 'copy');
    expect(find.text('复制'), findsNothing);

    await tester.tap(find.text('更多'));
    await tester.pump();
    await tester.pump();
    await tester.tap(find.text('分享'));
    await tester.pump();
    await tester.tap(find.text('更多'));
    await tester.pump();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pump();
    await tester.pump();
    expect(find.text('复制'), findsNothing);
  });

  testWidgets('dropdown menu rows show hover affordance', (tester) async {
    final theme = AnimalThemeData.fallback();

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          data: theme,
          child: Scaffold(
            body: AnimalDropdown<String>(
              items: const [
                AnimalDropdownItem(value: 'copy', label: Text('复制')),
                AnimalDropdownItem(value: 'delete', label: Text('删除')),
              ],
              onChanged: (_) {},
              child: const AnimalButton(child: Text('菜单')),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('菜单'));
    await tester.pump();
    await tester.pump();

    BoxDecoration rowDecoration() {
      final decorated = find.byWidgetPredicate((widget) {
        final decoration =
            widget is AnimatedContainer ? widget.decoration : null;
        if (decoration is! BoxDecoration ||
            decoration.borderRadius != BorderRadius.circular(12)) {
          return false;
        }
        final border = decoration.border;
        return border is Border && border.top.width == 1.5;
      });
      final container = tester.widget<AnimatedContainer>(decorated.first);
      return container.decoration! as BoxDecoration;
    }

    expect((rowDecoration().border! as Border).top.color, Colors.transparent);

    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer();
    await gesture.moveTo(tester.getCenter(find.text('复制')));
    await tester.pumpAndSettle();

    expect(
      (rowDecoration().border! as Border).top.color,
      theme.primaryColor,
    );

    await gesture.removePointer();
  });

  testWidgets('popover can render from controlled initial open state',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: AnimalPopover(
              open: true,
              content: Text('受控内容'),
              child: Text('触发'),
            ),
          ),
        ),
      ),
    );

    await tester.pump();
    await tester.pump();
    expect(find.text('受控内容'), findsOneWidget);
    final popoverPanel = find.byWidgetPredicate(
      (widget) =>
          widget is SizedBox &&
          widget.width == 260 &&
          widget.child.runtimeType.toString() == '_PopoverPanel',
    );
    expect(popoverPanel, findsOneWidget);
    expect(tester.getSize(popoverPanel).width, 260);
  });

  testWidgets('popover trigger supports keyboard open and escape',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: Center(
              child: AnimalPopover(
                content: Text('键盘内容'),
                child: Text('触发键盘'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('触发键盘'));
    await tester.pump();
    await tester.pump();
    expect(find.text('键盘内容'), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pump();
    await tester.pump();
    expect(find.text('键盘内容'), findsNothing);

    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    await tester.pump();
    expect(find.text('键盘内容'), findsOneWidget);
  });

  testWidgets('hover popover remains open when pointer enters panel',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: Center(
              child: AnimalPopover(
                trigger: AnimalPopoverTrigger.hover,
                content: SizedBox(width: 120, height: 40, child: Text('停留内容')),
                child: Text('Hover 触发'),
              ),
            ),
          ),
        ),
      ),
    );

    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer();
    await gesture.moveTo(tester.getCenter(find.text('Hover 触发')));
    await tester.pump();
    await tester.pump();
    expect(find.text('停留内容'), findsOneWidget);

    await gesture.moveTo(tester.getCenter(find.text('停留内容')));
    await tester.pump(const Duration(milliseconds: 160));
    expect(find.text('停留内容'), findsOneWidget);

    await gesture.moveTo(const Offset(20, 20));
    await tester.pump(const Duration(milliseconds: 160));
    await tester.pump();
    expect(find.text('停留内容'), findsNothing);

    await gesture.removePointer();
  });

  testWidgets('drawer and confirm dialog return expected result',
      (tester) async {
    bool? confirmResult;

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: Builder(
              builder: (context) {
                return Column(
                  children: [
                    AnimalButton(
                      onPressed: () => AnimalDrawer.show<void>(
                        context: context,
                        title: const Text('背包'),
                        child: const Text('抽屉内容'),
                      ),
                      child: const Text('打开抽屉'),
                    ),
                    AnimalButton(
                      onPressed: () async {
                        confirmResult = await AnimalConfirmDialog.show(
                          context: context,
                          title: const Text('确认'),
                          content: const Text('确定继续？'),
                        );
                      },
                      child: const Text('确认弹窗'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('打开抽屉'));
    await tester.pumpAndSettle();
    expect(find.text('抽屉内容'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();
    expect(find.text('抽屉内容'), findsNothing);

    await tester.tap(find.text('确认弹窗'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('确定').last);
    await tester.pumpAndSettle();
    expect(confirmResult, isTrue);
  });

  testWidgets('drawer can be dismissed with escape key', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: Builder(
              builder: (context) {
                return AnimalButton(
                  onPressed: () => AnimalDrawer.show<void>(
                    context: context,
                    title: const Text('背包'),
                    child: const Text('抽屉内容'),
                  ),
                  child: const Text('打开抽屉'),
                );
              },
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('打开抽屉'));
    await tester.pumpAndSettle();
    expect(find.text('抽屉内容'), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.text('抽屉内容'), findsNothing);
  });

  testWidgets('drawer close button shows hover affordance', (tester) async {
    final theme = AnimalThemeData.fallback();

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          data: theme,
          child: Scaffold(
            body: Builder(
              builder: (context) {
                return AnimalButton(
                  onPressed: () => AnimalDrawer.show<void>(
                    context: context,
                    title: const Text('背包'),
                    child: const Text('抽屉内容'),
                  ),
                  child: const Text('打开抽屉'),
                );
              },
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('打开抽屉'));
    await tester.pumpAndSettle();

    BoxDecoration closeDecoration() {
      final decorated = find.byWidgetPredicate((widget) {
        final decoration =
            widget is AnimatedContainer ? widget.decoration : null;
        return decoration is BoxDecoration &&
            decoration.shape == BoxShape.circle &&
            decoration.border is Border;
      });
      final container = tester.widget<AnimatedContainer>(decorated.last);
      return container.decoration! as BoxDecoration;
    }

    expect(
      (closeDecoration().border! as Border).top.color,
      theme.controlBorderColor,
    );

    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer();
    await gesture.moveTo(tester.getCenter(find.byIcon(Icons.close_rounded)));
    await tester.pumpAndSettle();

    expect(
      (closeDecoration().border! as Border).top.color,
      theme.primaryColor,
    );

    await gesture.removePointer();
  });

  testWidgets('descriptions statistic and timeline render content',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: Column(
              children: [
                AnimalDescriptions(
                  title: Text('岛屿信息'),
                  items: [
                    AnimalDescriptionItem(
                        label: Text('名称'), child: Text('星露岛')),
                    AnimalDescriptionItem(label: Text('水果'), child: Text('桃子')),
                  ],
                ),
                AnimalStatistic(
                  title: Text('访客'),
                  value: 128,
                  suffix: Text('人'),
                ),
                AnimalTimeline(
                  items: [
                    AnimalTimelineItem(
                      title: Text('出发'),
                      description: Text('整理背包'),
                      status: AnimalTimelineItemStatus.primary,
                    ),
                    AnimalTimelineItem(title: Text('到达')),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );

    expect(find.text('岛屿信息'), findsOneWidget);
    expect(find.text('128'), findsOneWidget);
    expect(find.text('整理背包'), findsOneWidget);
  });

  testWidgets('descriptions collapse columns in narrow containers',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: SizedBox(
              width: 150,
              child: AnimalDescriptions(
                column: 3,
                items: [
                  AnimalDescriptionItem(label: Text('名称'), child: Text('星露岛')),
                  AnimalDescriptionItem(label: Text('水果'), child: Text('桃子')),
                  AnimalDescriptionItem(label: Text('天气'), child: Text('晴朗')),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    final firstLabel = tester.getTopLeft(find.text('名称')).dy;
    final secondLabel = tester.getTopLeft(find.text('水果')).dy;
    expect(secondLabel, greaterThan(firstLabel));
  });

  testWidgets('timeline items support hover and keyboard activation',
      (tester) async {
    final theme = AnimalThemeData.fallback();
    var taps = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          data: theme,
          child: Scaffold(
            body: AnimalTimeline(
              items: [
                AnimalTimelineItem(
                  title: const Text('可点击节点'),
                  description: const Text('支持键盘'),
                  status: AnimalTimelineItemStatus.primary,
                  onTap: () => taps += 1,
                ),
                AnimalTimelineItem(
                  title: const Text('禁用节点'),
                  disabled: true,
                  onTap: () => taps += 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    BoxDecoration activeDecoration() {
      final decorated = find.byWidgetPredicate((widget) {
        final decoration =
            widget is AnimatedContainer ? widget.decoration : null;
        return decoration is BoxDecoration &&
            decoration.borderRadius == BorderRadius.circular(16) &&
            decoration.color != Colors.transparent;
      });
      final container = tester.widget<AnimatedContainer>(decorated.first);
      return container.decoration! as BoxDecoration;
    }

    await tester.tap(find.text('可点击节点'));
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pumpAndSettle();
    expect(taps, 3);

    await tester.tap(find.text('禁用节点'));
    await tester.pumpAndSettle();
    expect(taps, 3);

    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer();
    await gesture.moveTo(tester.getCenter(find.text('可点击节点')));
    await tester.pumpAndSettle();
    expect(activeDecoration().color, theme.subtleBackgroundColor);

    await gesture.removePointer();
  });

  testWidgets('calendar selects dates and changes months', (tester) async {
    DateTime? selected;
    DateTime? month;

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: AnimalCalendar(
              value: DateTime(2026, 5, 10),
              month: DateTime(2026, 5),
              firstDate: DateTime(2026, 5, 1),
              lastDate: DateTime(2026, 5, 31),
              onChanged: (value) => selected = value,
              onMonthChanged: (value) => month = value,
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('15'));
    await tester.pump();
    expect(selected, DateTime(2026, 5, 15));

    await tester.tap(find.byIcon(Icons.chevron_right_rounded));
    await tester.pump();
    expect(month, DateTime(2026, 6));
  });

  testWidgets('upload tree and result render interactive business states',
      (tester) async {
    AnimalUploadFile? removed;
    String? selectedNode;
    List<String>? expandedNodes;

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  AnimalUpload(
                    files: const [
                      AnimalUploadFile(
                        name: 'island-plan.pdf',
                        status: AnimalUploadStatus.uploading,
                        progress: 0.5,
                        size: '2 MB',
                      ),
                      AnimalUploadFile(
                        name: 'photo.png',
                        status: AnimalUploadStatus.done,
                      ),
                    ],
                    onTap: () {},
                    onRemove: (file) => removed = file,
                  ),
                  AnimalTree<String>(
                    selectedValue: 'rose',
                    defaultExpandedValues: const ['plants'],
                    onChanged: (value) => selectedNode = value,
                    onExpandedChanged: (values) => expandedNodes = values,
                    nodes: const [
                      AnimalTreeNode(
                        value: 'plants',
                        label: Text('植物'),
                        children: [
                          AnimalTreeNode(value: 'rose', label: Text('玫瑰')),
                        ],
                      ),
                    ],
                  ),
                  const AnimalResult(
                    status: AnimalResultStatus.success,
                    title: Text('提交成功'),
                    description: Text('岛屿资料已经保存。'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('island-plan.pdf'), findsOneWidget);
    expect(find.text('提交成功'), findsOneWidget);

    await tester.tap(
      find.descendant(
        of: find.ancestor(
          of: find.text('island-plan.pdf'),
          matching: find.byType(Container),
        ),
        matching: find.byIcon(Icons.close_rounded),
      ),
    );
    await tester.pump();
    expect(removed?.name, 'island-plan.pdf');

    await tester.tap(find.text('植物'));
    await tester.pump();
    expect(selectedNode, 'plants');
    expect(expandedNodes, isEmpty);
  });

  testWidgets('stage four form fields validate and update values',
      (tester) async {
    final formKey = GlobalKey<FormState>();
    var uploadFiles = const [
      AnimalUploadFile(name: 'island-plan.pdf'),
    ];
    DateTime? savedDate;
    String? savedNode;

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: SingleChildScrollView(
              child: AnimalForm(
                formKey: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    AnimalCalendarFormField(
                      defaultValue: DateTime(2026, 5, 10),
                      month: DateTime(2026, 5),
                      onSaved: (value) => savedDate = value,
                      validator: (value) => value == null ? '请选择预约日期' : null,
                    ),
                    AnimalUploadFormField(
                      files: uploadFiles,
                      onChanged: (files) => uploadFiles = files,
                      validator: (files) =>
                          files == null || files.isEmpty ? '请上传资料附件' : null,
                    ),
                    AnimalTreeFormField<String>(
                      nodes: const [
                        AnimalTreeNode(
                          value: 'plants',
                          label: Text('植物'),
                          children: [
                            AnimalTreeNode(value: 'rose', label: Text('玫瑰')),
                          ],
                        ),
                      ],
                      defaultExpandedValues: const ['plants'],
                      onSaved: (value) => savedNode = value,
                      validator: (value) => value == null ? '请选择一个图鉴节点' : null,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    expect(formKey.currentState!.validate(), isFalse);
    await tester.pump();
    expect(find.text('请选择一个图鉴节点'), findsOneWidget);

    await tester.ensureVisible(find.text('玫瑰'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('玫瑰'));
    await tester.pump();
    expect(formKey.currentState!.validate(), isTrue);

    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pump();
    expect(uploadFiles, isEmpty);
    expect(formKey.currentState!.validate(), isFalse);
    await tester.pump();
    expect(find.text('请上传资料附件'), findsOneWidget);

    formKey.currentState!.save();
    expect(savedDate, DateTime(2026, 5, 10));
    expect(savedNode, 'rose');
  });

  testWidgets('tree supports keyboard expand and collapse', (tester) async {
    List<String>? expandedNodes;

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: AnimalTree<String>(
              nodes: const [
                AnimalTreeNode(
                  value: 'plants',
                  label: Text('植物'),
                  children: [
                    AnimalTreeNode(value: 'rose', label: Text('玫瑰')),
                  ],
                ),
              ],
              onExpandedChanged: (values) => expandedNodes = values,
            ),
          ),
        ),
      ),
    );

    expect(find.text('玫瑰'), findsNothing);

    await tester.tap(find.text('植物'));
    await tester.pump();
    expect(find.text('玫瑰'), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await tester.pump();
    expect(expandedNodes, isEmpty);
    expect(find.text('玫瑰'), findsNothing);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pump();
    expect(expandedNodes, const ['plants']);
    expect(find.text('玫瑰'), findsOneWidget);
  });

  testWidgets('calendar supports keyboard date and month navigation',
      (tester) async {
    DateTime? selected;
    DateTime? month;

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: AnimalCalendar(
              value: DateTime(2026, 5, 10),
              month: DateTime(2026, 5),
              firstDate: DateTime(2026, 5, 1),
              lastDate: DateTime(2026, 6, 30),
              onChanged: (value) => selected = value,
              onMonthChanged: (value) => month = value,
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('10').first);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pump();
    expect(selected, DateTime(2026, 5, 11));

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pump();
    expect(selected, DateTime(2026, 5, 17));

    await tester.sendKeyEvent(LogicalKeyboardKey.pageDown);
    await tester.pump();
    expect(selected, DateTime(2026, 6, 10));
    expect(month, DateTime(2026, 6));
  });

  testWidgets('upload can be activated from keyboard focus', (tester) async {
    var taps = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: AnimalUpload(
              onTap: () => taps += 1,
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('上传文件'));
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pump();

    expect(taps, 3);
  });

  testWidgets('upload drop area shows hover and focus affordance',
      (tester) async {
    final theme = AnimalThemeData.fallback();

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          data: theme,
          child: Scaffold(
            body: AnimalUpload(
              onTap: () {},
            ),
          ),
        ),
      ),
    );

    BoxDecoration uploadDecoration() {
      final decorated = find.byWidgetPredicate((widget) {
        final decoration =
            widget is AnimatedContainer ? widget.decoration : null;
        return decoration is BoxDecoration &&
            decoration.borderRadius == BorderRadius.circular(24);
      });
      final container = tester.widget<AnimatedContainer>(decorated.first);
      return container.decoration! as BoxDecoration;
    }

    expect(
      (uploadDecoration().border! as Border).top.color,
      theme.controlBorderColor,
    );

    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer();
    await gesture.moveTo(tester.getCenter(find.text('上传文件')));
    await tester.pumpAndSettle();
    expect(
      (uploadDecoration().border! as Border).top.color,
      theme.primaryColor,
    );

    await tester.tap(find.text('上传文件'));
    await tester.pumpAndSettle();
    expect(
      (uploadDecoration().border! as Border).top.color,
      theme.primaryColor,
    );

    await gesture.removePointer();
  });

  testWidgets('upload remove button supports keyboard activation',
      (tester) async {
    var removed = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: AnimalUpload(
              files: const [
                AnimalUploadFile(name: 'island-plan.pdf'),
              ],
              onRemove: (_) => removed += 1,
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pumpAndSettle();

    expect(removed, 3);
  });

  testWidgets('calendar navigation buttons show hover affordance',
      (tester) async {
    final theme = AnimalThemeData.fallback();

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          data: theme,
          child: Scaffold(
            body: AnimalCalendar(
              month: DateTime(2026, 5),
            ),
          ),
        ),
      ),
    );

    BoxDecoration navDecoration() {
      final decorated = find.byWidgetPredicate((widget) {
        final decoration =
            widget is AnimatedContainer ? widget.decoration : null;
        return decoration is BoxDecoration &&
            decoration.shape == BoxShape.circle &&
            decoration.border is Border;
      });
      final container = tester.widget<AnimatedContainer>(decorated.first);
      return container.decoration! as BoxDecoration;
    }

    expect(
      (navDecoration().border! as Border).top.color,
      theme.controlBorderColor,
    );

    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer();
    await gesture
        .moveTo(tester.getCenter(find.byIcon(Icons.chevron_left_rounded)));
    await tester.pumpAndSettle();

    expect(
      (navDecoration().border! as Border).top.color,
      theme.primaryColor,
    );

    await gesture.removePointer();
  });

  testWidgets('tree node rows show hover and focus affordance', (tester) async {
    final theme = AnimalThemeData.fallback();

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          data: theme,
          child: const Scaffold(
            body: AnimalTree<String>(
              nodes: [
                AnimalTreeNode(value: 'plants', label: Text('植物')),
              ],
            ),
          ),
        ),
      ),
    );

    BoxDecoration rowDecoration() {
      final decorated = find.byWidgetPredicate((widget) {
        final decoration =
            widget is AnimatedContainer ? widget.decoration : null;
        if (decoration is! BoxDecoration ||
            decoration.borderRadius != BorderRadius.circular(16)) {
          return false;
        }
        final border = decoration.border;
        return border is Border && border.top.width == 1.5;
      });
      final container = tester.widget<AnimatedContainer>(decorated.first);
      return container.decoration! as BoxDecoration;
    }

    expect((rowDecoration().border! as Border).top.color, Colors.transparent);

    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer();
    await gesture.moveTo(tester.getCenter(find.text('植物')));
    await tester.pumpAndSettle();

    expect(
      (rowDecoration().border! as Border).top.color,
      theme.controlBorderColor,
    );

    await tester.tap(find.text('植物'));
    await tester.pumpAndSettle();
    expect(
      (rowDecoration().border! as Border).top.color,
      theme.controlBorderColor,
    );

    await gesture.removePointer();
  });

  testWidgets('table exposes horizontal scroll for narrow viewports',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: SizedBox(
              width: 260,
              child: AnimalTable<Map<String, String>>(
                columns: const [
                  AnimalTableColumn(
                    title: Text('名称'),
                    width: 160,
                    cellBuilder: _nameCell,
                  ),
                  AnimalTableColumn(
                    title: Text('位置'),
                    width: 180,
                    cellBuilder: _locationCell,
                  ),
                  AnimalTableColumn(
                    title: Text('状态'),
                    width: 160,
                    cellBuilder: _statusCell,
                  ),
                ],
                rows: const [
                  {
                    'name': 'Tom Nook',
                    'location': 'Resident Services',
                    'status': 'Ready',
                  },
                ],
              ),
            ),
          ),
        ),
      ),
    );

    final horizontalScroll = find.descendant(
      of: find.byType(AnimalTable<Map<String, String>>),
      matching: find.byWidgetPredicate((widget) {
        return widget is SingleChildScrollView &&
            widget.scrollDirection == Axis.horizontal;
      }),
    );

    expect(horizontalScroll, findsOneWidget);
  });

  testWidgets('mobile nav bar renders back action and triggers callback',
      (tester) async {
    var backs = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: AnimalMobileNavBar(
              title: const Text('移动页面'),
              showBackButton: true,
              safeAreaTop: false,
              onBack: () => backs += 1,
            ),
          ),
        ),
      ),
    );

    expect(find.text('移动页面'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await tester.pump();

    expect(backs, 1);
  });

  testWidgets('bottom bar changes selection and exposes selected semantics',
      (tester) async {
    var current = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                bottomNavigationBar: AnimalBottomBar(
                  currentIndex: current,
                  safeAreaBottom: false,
                  onChanged: (value) => setState(() => current = value),
                  items: const [
                    AnimalBottomBarItem(
                      icon: Icon(Icons.home_rounded),
                      label: Text('首页'),
                    ),
                    AnimalBottomBarItem(
                      icon: Icon(Icons.widgets_rounded),
                      label: Text('组件'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );

    expect(current, 0);
    await tester.tap(find.text('组件'));
    await tester.pumpAndSettle();

    expect(current, 1);

    final selectedSemantics = find
        .ancestor(
          of: find.text('组件'),
          matching: find.byType(Semantics),
        )
        .evaluate()
        .map((element) => element.widget)
        .whereType<Semantics>()
        .where((widget) => widget.properties.selected == true);
    expect(selectedSemantics, isNotEmpty);
  });

  testWidgets('mobile list tile supports tap and keyboard activation',
      (tester) async {
    var taps = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: AnimalCellGroup(
              children: [
                AnimalListTile(
                  title: const Text('打开设置'),
                  subtitle: const Text('Enter 或 Space 也可以触发'),
                  onTap: () => taps += 1,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('打开设置'));
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pump();

    expect(taps, 3);
  });

  testWidgets('bottom sheet show displays title and content', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Builder(
            builder: (context) {
              return Scaffold(
                body: AnimalButton(
                  onPressed: () {
                    AnimalBottomSheet.show<void>(
                      context: context,
                      title: const Text('底部弹层'),
                      child: const Text('弹层内容'),
                    );
                  },
                  child: const Text('打开弹层'),
                ),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('打开弹层'));
    await tester.pumpAndSettle();

    expect(find.text('底部弹层'), findsOneWidget);
    expect(find.text('弹层内容'), findsOneWidget);
  });

  testWidgets('action sheet returns selected action value', (tester) async {
    String? selected;

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Builder(
            builder: (context) {
              return Scaffold(
                body: AnimalButton(
                  onPressed: () async {
                    selected = await AnimalActionSheet.show<String>(
                      context: context,
                      title: const Text('操作面板'),
                      actions: const [
                        AnimalActionSheetAction(
                          value: 'share',
                          label: Text('分享'),
                        ),
                        AnimalActionSheetAction(
                          value: 'delete',
                          label: Text('删除'),
                          destructive: true,
                        ),
                      ],
                    );
                  },
                  child: const Text('打开操作'),
                ),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('打开操作'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('分享'));
    await tester.pumpAndSettle();

    expect(selected, 'share');
  });

  testWidgets('mobile search bar changes, searches and clears text',
      (tester) async {
    final changes = <String>[];
    String? searched;
    var cleared = false;

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: AnimalMobileSearchBar(
              initialValue: '岛',
              hintText: '搜索组件',
              onChanged: changes.add,
              onSearch: (value) => searched = value,
              onClear: () => cleared = true,
            ),
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), '岛屿');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pump();

    expect(changes.last, '岛屿');
    expect(searched, '岛屿');

    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pump();

    expect(changes.last, '');
    expect(cleared, isTrue);
  });

  testWidgets('picker bottom sheet returns selected option', (tester) async {
    String? selected;

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Builder(
            builder: (context) {
              return Scaffold(
                body: AnimalButton(
                  onPressed: () async {
                    selected = await AnimalPicker.show<String>(
                      context: context,
                      title: const Text('选择岛屿'),
                      options: const [
                        AnimalPickerOption(
                          value: 'forest',
                          label: Text('森林岛'),
                        ),
                        AnimalPickerOption(
                          value: 'sea',
                          label: Text('海风岛'),
                        ),
                      ],
                    );
                  },
                  child: const Text('打开选择器'),
                ),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('打开选择器'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('海风岛'));
    await tester.pumpAndSettle();

    expect(selected, 'sea');
  });

  testWidgets('mobile date picker confirms selected date', (tester) async {
    DateTime? selected;
    final date = DateTime(2026, 5, 22);

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: AnimalMobileDatePicker(
              value: date,
              onChanged: (value) => selected = value,
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.widgetWithText(AnimalButton, '确定'));
    await tester.pump();

    expect(selected, DateTime(2026, 5, 22));
  });

  testWidgets('mobile stepper clamps value and emits changes', (tester) async {
    final values = <num>[];

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: AnimalMobileStepper(
              defaultValue: 1,
              min: 0,
              max: 2,
              onChanged: values.add,
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.add_rounded));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.add_rounded));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.remove_rounded));
    await tester.pump();

    expect(values, [2, 1]);
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('swipe action reveals and triggers action', (tester) async {
    var deleted = false;

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: SizedBox(
              width: 320,
              height: 80,
              child: AnimalSwipeAction(
                actions: [
                  AnimalSwipeActionItem(
                    label: const Text('删除'),
                    icon: const Icon(Icons.delete_rounded),
                    destructive: true,
                    onTap: () => deleted = true,
                  ),
                ],
                child: const AnimalListTile(title: Text('可左滑项目')),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.drag(find.text('可左滑项目'), const Offset(-120, 0));
    await tester.pumpAndSettle();
    await tester.tap(find.text('删除'));
    await tester.pumpAndSettle();

    expect(deleted, isTrue);
  });

  testWidgets('pull refresh delegates refresh callback', (tester) async {
    var refreshed = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: AnimalPullRefresh(
              onRefresh: () async => refreshed += 1,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 700, child: Text('下拉刷新')),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    await tester.drag(find.text('下拉刷新'), const Offset(0, 320));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(refreshed, 1);
  });

  testWidgets('pull refresh uses animal indicator and supports desktop drag',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: AnimalPullRefresh(
              onRefresh: () async {},
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 700, child: Text('Animal 下拉刷新')),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    final configuration = tester.widget<ScrollConfiguration>(
      find.descendant(
        of: find.byType(AnimalPullRefresh),
        matching: find.byType(ScrollConfiguration),
      ),
    );

    expect(
        configuration.behavior.dragDevices, contains(PointerDeviceKind.mouse));
    expect(
      configuration.behavior.dragDevices,
      contains(PointerDeviceKind.trackpad),
    );
    expect(find.byType(RefreshProgressIndicator), findsNothing);

    final gesture = await tester.startGesture(
      tester.getCenter(find.text('Animal 下拉刷新')),
    );
    await gesture.moveBy(const Offset(0, 120));
    await tester.pump();

    expect(
      find.text('下拉唤醒岛屿').evaluate().isNotEmpty ||
          find.text('松开刷新岛屿').evaluate().isNotEmpty,
      isTrue,
    );

    await gesture.up();
    await tester.pumpAndSettle();
  });

  testWidgets('pull refresh does not show indicator or refresh on press only',
      (tester) async {
    var refreshed = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: AnimalPullRefresh(
              onRefresh: () async {
                refreshed += 1;
              },
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 700, child: Text('按住不刷新')),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    final gesture = await tester.startGesture(
      tester.getCenter(find.text('按住不刷新')),
    );
    await tester.pump(const Duration(milliseconds: 260));

    expect(find.text('下拉唤醒岛屿'), findsNothing);
    expect(find.text('松开刷新岛屿'), findsNothing);
    expect(refreshed, 0);

    await gesture.up();
    await tester.pumpAndSettle();

    expect(refreshed, 0);
  });

  testWidgets('pull refresh animal indicator keeps moving while visible',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: AnimalPullRefresh(
              onRefresh: () async {
                await Future<void>.delayed(const Duration(milliseconds: 700));
              },
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 700, child: Text('持续动画刷新')),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    final gesture = await tester.startGesture(
      tester.getCenter(find.text('持续动画刷新')),
    );
    await gesture.moveBy(const Offset(0, 120));
    await tester.pump();
    final firstRotationValues = tester
        .widgetList<RotationTransition>(find.byType(RotationTransition))
        .map((widget) => widget.turns.value)
        .toList();

    await tester.pump(const Duration(milliseconds: 220));
    final secondRotationValues = tester
        .widgetList<RotationTransition>(find.byType(RotationTransition))
        .map((widget) => widget.turns.value)
        .toList();

    expect(firstRotationValues, isNotEmpty);
    expect(secondRotationValues.length, firstRotationValues.length);
    expect(
      Iterable<int>.generate(firstRotationValues.length).any((index) {
        return (secondRotationValues[index] - firstRotationValues[index])
                .abs() >
            0.0001;
      }),
      isTrue,
    );

    await gesture.up();
    await tester.pumpAndSettle();
  });

  testWidgets('pull refresh can use material indicator options',
      (tester) async {
    bool notificationPredicate(ScrollNotification notification) => true;

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: AnimalPullRefresh(
              onRefresh: () async {},
              style: AnimalPullRefreshStyle.material,
              triggerMode: RefreshIndicatorTriggerMode.anywhere,
              notificationPredicate: notificationPredicate,
              semanticsLabel: '刷新任务',
              semanticsValue: '准备刷新',
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 700, child: Text('桌面下拉刷新')),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    final configuration = tester.widget<ScrollConfiguration>(
      find.descendant(
        of: find.byType(AnimalPullRefresh),
        matching: find.byType(ScrollConfiguration),
      ),
    );
    final indicator = tester.widget<RefreshIndicator>(
      find.descendant(
        of: find.byType(AnimalPullRefresh),
        matching: find.byType(RefreshIndicator),
      ),
    );

    expect(
      configuration.behavior.dragDevices,
      contains(PointerDeviceKind.mouse),
    );
    expect(
      configuration.behavior.dragDevices,
      contains(PointerDeviceKind.trackpad),
    );
    expect(indicator.triggerMode, RefreshIndicatorTriggerMode.anywhere);
    expect(indicator.notificationPredicate, same(notificationPredicate));
    expect(indicator.semanticsLabel, '刷新任务');
    expect(indicator.semanticsValue, '准备刷新');
  });

  testWidgets('mobile business cards render content and trigger callbacks',
      (tester) async {
    var productTaps = 0;
    var orderTaps = 0;
    var statTaps = 0;
    var couponTaps = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  AnimalMobileProductCard(
                    title: const Text('樱桃果篮'),
                    subtitle: const Text('今日特价'),
                    price: const Text('120 铃钱'),
                    onTap: () => productTaps += 1,
                  ),
                  AnimalMobileOrderCard(
                    orderNo: const Text('订单 #A001'),
                    status: const Text('配送中'),
                    total: const Text('合计 320'),
                    onTap: () => orderTaps += 1,
                    items: const [
                      AnimalMobileOrderItem(
                        title: Text('花园椅'),
                        quantity: 2,
                        price: Text('160'),
                      ),
                    ],
                  ),
                  AnimalMobileProfileHeader(
                    name: const Text('狸克'),
                    subtitle: const Text('岛屿居民服务处'),
                    stats: [
                      AnimalMobileStatItem(
                        label: const Text('订单'),
                        value: const Text('12'),
                        onTap: () => statTaps += 1,
                      ),
                    ],
                  ),
                  AnimalMobileCouponCard(
                    amount: const Text('-20'),
                    title: const Text('新人券'),
                    description: const Text('满 100 可用'),
                    onTap: () => couponTaps += 1,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('樱桃果篮'), findsOneWidget);
    expect(find.text('订单 #A001'), findsOneWidget);
    expect(find.text('狸克'), findsOneWidget);
    expect(find.text('新人券'), findsOneWidget);

    await tester.tap(find.text('樱桃果篮'));
    await tester.pump();
    await tester.tap(find.text('订单 #A001'));
    await tester.pump();
    await tester.tap(find.text('12'));
    await tester.pump();
    await tester.tap(find.text('领取'));
    await tester.pump();

    expect(productTaps, 1);
    expect(orderTaps, 1);
    expect(statTaps, 1);
    expect(couponTaps, 1);
  });

  testWidgets('mobile checkout business components render and trigger actions',
      (tester) async {
    var noticeTaps = 0;
    var addressTaps = 0;
    var checkoutTaps = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: Column(
              children: [
                AnimalMobileNoticeBar(
                  type: AnimalMobileNoticeType.warning,
                  action: const Text('查看'),
                  showChevron: true,
                  onTap: () => noticeTaps += 1,
                  child: const Text('配送可能延迟'),
                ),
                AnimalMobileAddressCard(
                  selected: true,
                  name: const Text('狸克'),
                  phone: const Text('138 0000 0522'),
                  address: const Text('星露岛 居民服务处旁'),
                  onTap: () => addressTaps += 1,
                ),
                const AnimalMobilePriceSummary(
                  items: [
                    AnimalMobilePriceItem(
                      label: Text('商品金额'),
                      value: Text('560 铃钱'),
                    ),
                    AnimalMobilePriceItem(
                      label: Text('优惠券'),
                      value: Text('-20 铃钱'),
                      emphasized: true,
                    ),
                  ],
                  total: Text('540 铃钱'),
                ),
                AnimalMobileCheckoutBar(
                  safeAreaBottom: false,
                  total: const Text('540 铃钱'),
                  action: AnimalButton(
                    type: AnimalButtonType.primary,
                    onPressed: () => checkoutTaps += 1,
                    child: const Text('去结算'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    expect(find.text('配送可能延迟'), findsOneWidget);
    expect(find.text('星露岛 居民服务处旁'), findsOneWidget);
    expect(find.text('优惠券'), findsOneWidget);
    expect(find.text('去结算'), findsOneWidget);

    await tester.tap(find.text('配送可能延迟'));
    await tester.pump();
    await tester.tap(find.text('狸克'));
    await tester.pump();
    await tester.tap(find.text('去结算'));
    await tester.pump();

    expect(noticeTaps, 1);
    expect(addressTaps, 1);
    expect(checkoutTaps, 1);
  });

  testWidgets('mobile cart and order flow components trigger callbacks',
      (tester) async {
    bool? selected;
    num? quantity;
    var timelineTaps = 0;
    var paymentTaps = 0;
    var emptyTaps = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: AnimalTheme(
          child: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  AnimalMobileCartItem(
                    selected: true,
                    onSelectedChanged: (value) => selected = value,
                    title: const Text('樱桃果篮'),
                    subtitle: const Text('规格：大份'),
                    price: const Text('120 铃钱'),
                    quantity: 2,
                    onQuantityChanged: (value) => quantity = value,
                  ),
                  AnimalMobileOrderTimeline(
                    items: [
                      AnimalMobileTimelineItem(
                        title: const Text('订单已提交'),
                        time: const Text('09:30'),
                        status: AnimalMobileTimelineStatus.success,
                        onTap: () => timelineTaps += 1,
                      ),
                      const AnimalMobileTimelineItem(
                        title: Text('等待签收'),
                        status: AnimalMobileTimelineStatus.warning,
                      ),
                    ],
                  ),
                  AnimalMobilePaymentMethodCard(
                    selected: true,
                    title: const Text('铃钱钱包'),
                    subtitle: const Text('余额充足'),
                    onTap: () => paymentTaps += 1,
                  ),
                  AnimalMobileEmptyAction(
                    title: const Text('购物车还是空的'),
                    description: const Text('去挑选一些岛屿好物'),
                    action: AnimalButton(
                      type: AnimalButtonType.primary,
                      onPressed: () => emptyTaps += 1,
                      child: const Text('去逛逛'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('樱桃果篮'), findsOneWidget);
    expect(find.text('订单已提交'), findsOneWidget);
    expect(find.text('铃钱钱包'), findsOneWidget);
    expect(find.text('购物车还是空的'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.check_rounded).first);
    await tester.pump();
    await tester.tap(find.byIcon(Icons.add_rounded).first);
    await tester.pump();
    await tester.tap(find.text('订单已提交'));
    await tester.pump();
    await tester.tap(find.text('铃钱钱包'));
    await tester.pump();
    await tester.tap(find.text('去逛逛'));
    await tester.pump();

    expect(selected, false);
    expect(quantity, 3);
    expect(timelineTaps, 1);
    expect(paymentTaps, 1);
    expect(emptyTaps, 1);
  });

  test('release metadata and scripts are ready for pub.dev', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    final pubignore = File('.pubignore').readAsStringSync();
    final qualityScript = File('tool/quality_check.ps1').readAsStringSync();
    final docsScript = File('tool/build_docs.ps1').readAsStringSync();
    final workflow = File('.github/workflows/quality.yml').readAsStringSync();
    final checklist = File('RELEASE_CHECKLIST.md').readAsStringSync();

    expect(pubspec, contains('issue_tracker:'));
    expect(pubspec, contains('topics:'));
    expect(pubspec, contains('screenshots:'));
    expect(pubignore, contains('example/web/mobile_preview/'));
    expect(qualityScript, contains('pub publish --dry-run'));
    expect(qualityScript, isNot(contains('example_mobile_preview')));
    expect(qualityScript, contains('mobile_preview'));
    expect(
      docsScript,
      contains('[string]\$MobilePreviewBaseHref = "/mobile_preview/"'),
    );
    expect(
      docsScript,
      contains(
        '& \$Flutter build web --base-href \$MobilePreviewBaseHref --pwa-strategy=none',
      ),
    );
    expect(workflow, contains('Root publish dry run'));
    expect(workflow, contains('flutter pub publish --dry-run'));
    expect(workflow, contains('FLUTTER_VERSION: 3.41.0'));
    expect(workflow, contains('PUB_HOSTED_URL: https://pub.dev'));
    expect(workflow, contains('--branch "\$FLUTTER_VERSION"'));
    expect(workflow, isNot(contains('uses:')));
    expect(checklist, contains('Platform Smoke Test'));
  });
}

Widget _nameCell(BuildContext context, Map<String, String> row, int index) {
  return Text(row['name']!);
}

Widget _locationCell(BuildContext context, Map<String, String> row, int index) {
  return Text(row['location']!);
}

Widget _statusCell(BuildContext context, Map<String, String> row, int index) {
  return Text(row['status']!);
}
