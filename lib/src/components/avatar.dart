import 'package:flutter/material.dart';

import '../animal_theme.dart';
import 'icon.dart';

enum AnimalAvatarSize { small, middle, large }

enum AnimalAvatarShape { circle, square }

class AnimalAvatar extends StatelessWidget {
  const AnimalAvatar({
    super.key,
    this.child,
    this.image,
    this.imageUrl,
    this.icon,
    this.size = AnimalAvatarSize.middle,
    this.shape = AnimalAvatarShape.circle,
    this.backgroundColor,
    this.foregroundColor,
  });

  final Widget? child;
  final ImageProvider? image;
  final String? imageUrl;
  final AnimalIconName? icon;
  final AnimalAvatarSize size;
  final AnimalAvatarShape shape;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final side = _avatarSide(size);
    final radius = shape == AnimalAvatarShape.circle ? side / 2 : 16.0;
    final provider =
        image ?? (imageUrl == null ? null : NetworkImage(imageUrl!));
    final foreground = foregroundColor ?? const Color(0xFF725D42);

    Widget content;
    if (provider != null) {
      content = Image(image: provider, fit: BoxFit.cover);
    } else if (child != null) {
      content = DefaultTextStyle.merge(
        style: theme.textStyle(
          size: side * 0.38,
          weight: FontWeight.w900,
          color: foreground,
        ),
        child: FittedBox(fit: BoxFit.scaleDown, child: child),
      );
    } else if (icon != null) {
      content = AnimalIcon(name: icon!, size: side * 0.58);
    } else {
      content = Icon(
        Icons.person_rounded,
        size: side * 0.58,
        color: foreground,
      );
    }

    return Container(
      width: side,
      height: side,
      decoration: BoxDecoration(
        color: backgroundColor ?? const Color(0xFFFFF8D6),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: const Color(0xFFD9C889), width: 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFFBDAEA0),
            offset: Offset(0, 3),
            blurRadius: 0,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Center(child: content),
    );
  }
}

double _avatarSide(AnimalAvatarSize size) {
  return switch (size) {
    AnimalAvatarSize.small => 32,
    AnimalAvatarSize.middle => 44,
    AnimalAvatarSize.large => 64,
  };
}
