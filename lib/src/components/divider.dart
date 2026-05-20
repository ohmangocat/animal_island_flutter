import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum AnimalDividerType {
  lineBrown,
  lineTeal,
  lineWhite,
  lineYellow,
  waveYellow,
}

class AnimalDivider extends StatelessWidget {
  const AnimalDivider({
    super.key,
    this.type = AnimalDividerType.lineBrown,
    this.height = 12,
  });

  final AnimalDividerType type;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: type == AnimalDividerType.lineWhite
          ? Image.asset(
              _assetFor(type),
              package: 'animal_island_flutter',
              fit: BoxFit.contain,
              repeat: ImageRepeat.repeatX,
            )
          : SvgPicture.asset(
              _assetFor(type),
              package: 'animal_island_flutter',
              fit: BoxFit.contain,
            ),
    );
  }

  String _assetFor(AnimalDividerType type) {
    return switch (type) {
      AnimalDividerType.lineBrown =>
        'assets/animal_island/img/dividers/divider-line-brown.svg',
      AnimalDividerType.lineTeal =>
        'assets/animal_island/img/dividers/divider-line-teal.svg',
      AnimalDividerType.lineWhite =>
        'assets/animal_island/img/dividers/divider-line-white.png',
      AnimalDividerType.lineYellow =>
        'assets/animal_island/img/dividers/divider-line-yellow.svg',
      AnimalDividerType.waveYellow =>
        'assets/animal_island/img/dividers/wave-yellow.svg',
    };
  }
}

class AnimalAssetImage extends StatelessWidget {
  const AnimalAssetImage({
    super.key,
    required this.asset,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  });

  final String asset;
  final double? width;
  final double? height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    if (asset.endsWith('.svg')) {
      return SvgPicture.asset(
        asset,
        package: 'animal_island_flutter',
        width: width,
        height: height,
        fit: fit,
      );
    }

    return Image.asset(
      asset,
      package: 'animal_island_flutter',
      width: width,
      height: height,
      fit: fit,
    );
  }
}

class AnimalAssetDecoration extends StatelessWidget {
  const AnimalAssetDecoration({
    super.key,
    required this.asset,
    required this.height,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
  });

  final String asset;
  final double height;
  final BoxFit fit;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: Align(
        alignment: alignment,
        child: AnimalAssetImage(
          asset: asset,
          height: height,
          fit: fit,
        ),
      ),
    );
  }
}
