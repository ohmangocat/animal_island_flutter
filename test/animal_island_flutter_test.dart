import 'package:animal_island_flutter/animal_island_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
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
}
