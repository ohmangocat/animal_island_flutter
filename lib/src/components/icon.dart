import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum AnimalIconName {
  miles,
  camera,
  chat,
  critterpedia,
  design,
  diy,
  helicopter,
  map,
  shopping,
  variant,
}

@immutable
class AnimalIconInfo {
  const AnimalIconInfo({
    required this.name,
    required this.label,
    required this.asset,
  });

  final AnimalIconName name;
  final String label;
  final String asset;
}

const animalIconList = <AnimalIconInfo>[
  AnimalIconInfo(
    name: AnimalIconName.miles,
    label: 'Miles',
    asset: 'assets/animal_island/img/icons/icon-miles.svg',
  ),
  AnimalIconInfo(
    name: AnimalIconName.camera,
    label: 'Camera',
    asset: 'assets/animal_island/img/icons/icon-camera.svg',
  ),
  AnimalIconInfo(
    name: AnimalIconName.chat,
    label: 'Chat',
    asset: 'assets/animal_island/img/icons/icon-chat.svg',
  ),
  AnimalIconInfo(
    name: AnimalIconName.critterpedia,
    label: 'Critterpedia',
    asset: 'assets/animal_island/img/icons/icon-critterpedia.svg',
  ),
  AnimalIconInfo(
    name: AnimalIconName.design,
    label: 'Design',
    asset: 'assets/animal_island/img/icons/icon-design.svg',
  ),
  AnimalIconInfo(
    name: AnimalIconName.diy,
    label: 'DIY',
    asset: 'assets/animal_island/img/icons/icon-diy.svg',
  ),
  AnimalIconInfo(
    name: AnimalIconName.helicopter,
    label: 'Helicopter',
    asset: 'assets/animal_island/img/icons/icon-helicopter.svg',
  ),
  AnimalIconInfo(
    name: AnimalIconName.map,
    label: 'Map',
    asset: 'assets/animal_island/img/icons/icon-map.svg',
  ),
  AnimalIconInfo(
    name: AnimalIconName.shopping,
    label: 'Shopping',
    asset: 'assets/animal_island/img/icons/icon-shopping.svg',
  ),
  AnimalIconInfo(
    name: AnimalIconName.variant,
    label: 'Variant',
    asset: 'assets/animal_island/img/icons/icon-variant.svg',
  ),
];

class AnimalIcon extends StatefulWidget {
  const AnimalIcon({
    super.key,
    required this.name,
    this.size = 24,
    this.bounce = false,
  });

  final AnimalIconName name;
  final double size;
  final bool bounce;

  @override
  State<AnimalIcon> createState() => _AnimalIconState();
}

class _AnimalIconState extends State<AnimalIcon> {
  bool _hovered = false;

  AnimalIconInfo get _info =>
      animalIconList.firstWhere((info) => info.name == widget.name);

  @override
  Widget build(BuildContext context) {
    final icon = AnimatedScale(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      scale: widget.bounce && _hovered ? 1.1 : 1,
      child: AnimatedRotation(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        turns: widget.bounce && _hovered ? -4 / 360 : 0,
        child: SizedBox(
          width: widget.size,
          height: widget.size,
          child: SvgPicture.asset(
            _info.asset,
            package: 'animal_island_flutter',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );

    if (!widget.bounce) {
      return icon;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: icon,
    );
  }
}
