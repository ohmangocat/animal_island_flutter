import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum AnimalFooterType { sea, tree }

class AnimalFooter extends StatelessWidget {
  const AnimalFooter({
    super.key,
    this.type = AnimalFooterType.tree,
    this.height,
  });

  final AnimalFooterType type;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height ?? 80,
      child: type == AnimalFooterType.sea
          ? SvgPicture.asset(
              'assets/animal_island/img/footer/footer-sea.svg',
              package: 'animal_island_flutter',
              fit: BoxFit.contain,
              alignment: Alignment.center,
            )
          : Image.asset(
              'assets/animal_island/img/footer/footer-tree.webp',
              package: 'animal_island_flutter',
              fit: BoxFit.cover,
              alignment: Alignment.bottomCenter,
            ),
    );
  }
}
