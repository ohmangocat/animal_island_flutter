import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../animal_theme.dart';
import 'icon.dart';

const _phoneApps = <_PhoneApp>[
  _PhoneApp(
    name: AnimalIconName.camera,
    color: Color(0xFFB77DEE),
    hasNewMessage: true,
  ),
  _PhoneApp(
    name: AnimalIconName.miles,
    color: Color(0xFF889DF0),
    offset: true,
  ),
  _PhoneApp(
    name: AnimalIconName.critterpedia,
    color: Color(0xFFF7CD67),
    iconWidth: 105,
  ),
  _PhoneApp(name: AnimalIconName.diy, color: Color(0xFFE59266)),
  _PhoneApp(name: AnimalIconName.design, color: Color(0xFFF8A6B2)),
  _PhoneApp(
    name: AnimalIconName.map,
    color: Color(0xFF82D5BB),
    iconWidth: 90,
    hasNewMessage: true,
  ),
  _PhoneApp(
    name: AnimalIconName.variant,
    color: Color(0xFF8AC68A),
    iconWidth: 80,
  ),
  _PhoneApp(name: AnimalIconName.helicopter, color: Color(0xFFFC736D)),
  _PhoneApp(name: AnimalIconName.chat, color: Color(0xFFD1DA49)),
];

class AnimalPhone extends StatefulWidget {
  const AnimalPhone({
    super.key,
    this.width = 527,
    this.height = 788,
  });

  final double width;
  final double height;

  @override
  State<AnimalPhone> createState() => _AnimalPhoneState();
}

class _AnimalPhoneState extends State<AnimalPhone> {
  late DateTime _now;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final aspect = widget.width / widget.height;

    return AspectRatio(
      aspectRatio: aspect,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final scale = constraints.maxWidth / widget.width;
          return Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF8F4E8),
              borderRadius: BorderRadius.circular(136 * scale),
            ),
            clipBehavior: Clip.antiAlias,
            child: _PhoneScreen(now: _now, scale: scale),
          );
        },
      ),
    );
  }
}

class _PhoneScreen extends StatelessWidget {
  const _PhoneScreen({
    required this.now,
    required this.scale,
  });

  final DateTime now;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final hour12 = now.hour % 12 == 0 ? 12 : now.hour % 12;
    final minute = now.minute.toString().padLeft(2, '0');
    final ampm = now.hour >= 12 ? 'PM' : 'AM';

    return Stack(
      children: [
        const Positioned.fill(child: ColoredBox(color: Color(0xFFF8F4E8))),
        Positioned(
          top: 40 * scale,
          left: 70 * scale,
          right: 70 * scale,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SvgPicture.asset(
                    'assets/animal_island/img/icons/wifi.svg',
                    package: 'animal_island_flutter',
                    width: 79 * scale,
                    height: 29 * scale,
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: '$hour12'),
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: _BlinkingColon(scale: scale),
                        ),
                        TextSpan(text: '$minute$ampm'),
                      ],
                    ),
                    style: theme.textStyle(
                        size: 32 * scale,
                        weight: FontWeight.w900,
                        color: const Color(0xFFDDDBCC)),
                  ),
                  SvgPicture.asset(
                    'assets/animal_island/img/icons/location.svg',
                    package: 'animal_island_flutter',
                    width: 36 * scale,
                    height: 36 * scale,
                  ),
                ],
              ),
              SizedBox(height: 20 * scale),
              Text(
                'Welcome!',
                style: theme.textStyle(
                  size: 48 * scale,
                  weight: FontWeight.w900,
                  color: const Color(0xFF725C4E),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 40 * scale,
          right: 40 * scale,
          top: 225 * scale,
          child: GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            mainAxisSpacing: 32 * scale,
            crossAxisSpacing: 32 * scale,
            children: [
              for (final app in _phoneApps)
                _PhoneAppTile(app: app, scale: scale),
            ],
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 50 * scale,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/animal_island/img/icons/page.svg',
                package: 'animal_island_flutter',
                width: 65 * scale,
                height: 32 * scale,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BlinkingColon extends StatefulWidget {
  const _BlinkingColon({required this.scale});

  final double scale;

  @override
  State<_BlinkingColon> createState() => _BlinkingColonState();
}

class _BlinkingColonState extends State<_BlinkingColon> {
  Timer? _timer;
  bool _visible = true;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      setState(() => _visible = !_visible);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    return AnimatedOpacity(
      opacity: _visible ? 1 : 0,
      duration: Duration.zero,
      child: Text(
        ':',
        style: theme.textStyle(
          size: 32 * widget.scale,
          weight: FontWeight.w900,
          color: const Color(0xFFDDDBCC),
        ),
      ),
    );
  }
}

class _PhoneApp {
  const _PhoneApp({
    required this.name,
    required this.color,
    this.offset = false,
    this.hasNewMessage = false,
    this.iconWidth,
  });

  final AnimalIconName name;
  final Color color;
  final bool offset;
  final bool hasNewMessage;
  final double? iconWidth;
}

class _PhoneAppTile extends StatelessWidget {
  const _PhoneAppTile({
    required this.app,
    required this.scale,
  });

  final _PhoneApp app;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final iconSize = (app.iconWidth ?? 86) * scale;

    return Center(
      child: Container(
        width: 123 * scale,
        height: 123 * scale,
        decoration: BoxDecoration(
          color: app.color,
          borderRadius: BorderRadius.circular(45 * scale),
        ),
        clipBehavior: app.offset ? Clip.antiAlias : Clip.none,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            if (app.hasNewMessage)
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  width: 28 * scale,
                  height: 28 * scale,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF544A),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFF8F4E8),
                      width: 5 * scale,
                    ),
                  ),
                ),
              ),
            Center(
              child: Transform.translate(
                offset: Offset(0, app.offset ? 15 * scale : 0),
                child: AnimalIcon(
                  name: app.name,
                  size: iconSize,
                  bounce: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
