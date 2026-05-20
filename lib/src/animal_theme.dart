import 'package:flutter/material.dart';

@immutable
class AnimalThemeData extends ThemeExtension<AnimalThemeData> {
  const AnimalThemeData({
    required this.primaryColor,
    required this.primaryHoverColor,
    required this.primaryActiveColor,
    required this.primaryBackgroundColor,
    required this.successColor,
    required this.warningColor,
    required this.errorColor,
    required this.textColor,
    required this.secondaryTextColor,
    required this.disabledTextColor,
    required this.borderColor,
    required this.borderHoverColor,
    required this.lightBorderColor,
    required this.backgroundColor,
    required this.secondaryBackgroundColor,
    required this.disabledBackgroundColor,
    required this.shadowColor,
    required this.fontFamily,
    required this.fontPackage,
    required this.borderWidth,
    required this.radiusSmall,
    required this.radius,
    required this.radiusLarge,
    required this.heightSmall,
    required this.height,
    required this.heightLarge,
  });

  factory AnimalThemeData.fallback() {
    return const AnimalThemeData(
      primaryColor: Color(0xFF19C8B9),
      primaryHoverColor: Color(0xFF3DD4C6),
      primaryActiveColor: Color(0xFF50B9AB),
      primaryBackgroundColor: Color(0xFFE6F9F6),
      successColor: Color(0xFF6FBA2C),
      warningColor: Color(0xFFF5C31C),
      errorColor: Color(0xFFE05A5A),
      textColor: Color(0xFF794F27),
      secondaryTextColor: Color(0xFF9F927D),
      disabledTextColor: Color(0xFFC4B89E),
      borderColor: Color(0xFFAAA69D),
      borderHoverColor: Color(0xFF827157),
      lightBorderColor: Color(0xFFE8E2D6),
      backgroundColor: Color(0xFFF8F8F0),
      secondaryBackgroundColor: Color(0xFFF0E8D8),
      disabledBackgroundColor: Color(0xFFF0ECE2),
      shadowColor: Color(0xFF3D3428),
      fontFamily: 'Nunito',
      fontPackage: 'animal_island_flutter',
      borderWidth: 2,
      radiusSmall: 16,
      radius: 18,
      radiusLarge: 24,
      heightSmall: 32,
      height: 40,
      heightLarge: 48,
    );
  }

  final Color primaryColor;
  final Color primaryHoverColor;
  final Color primaryActiveColor;
  final Color primaryBackgroundColor;
  final Color successColor;
  final Color warningColor;
  final Color errorColor;
  final Color textColor;
  final Color secondaryTextColor;
  final Color disabledTextColor;
  final Color borderColor;
  final Color borderHoverColor;
  final Color lightBorderColor;
  final Color backgroundColor;
  final Color secondaryBackgroundColor;
  final Color disabledBackgroundColor;
  final Color shadowColor;
  final String fontFamily;
  final String? fontPackage;
  final double borderWidth;
  final double radiusSmall;
  final double radius;
  final double radiusLarge;
  final double heightSmall;
  final double height;
  final double heightLarge;

  TextStyle textStyle({
    double size = 14,
    FontWeight weight = FontWeight.w600,
    Color? color,
  }) {
    return TextStyle(
      color: color ?? textColor,
      fontFamily: fontFamily,
      fontFamilyFallback: const [
        'Noto Sans SC',
        'Zen Maru Gothic',
        'HarmonyOS Sans SC',
        'MiSans',
        'PingFang SC',
        'Hiragino Sans GB',
        'Microsoft YaHei',
        'sans-serif',
      ],
      package: fontPackage,
      fontSize: size,
      fontWeight: weight,
      height: 1.5715,
      letterSpacing: 0,
    );
  }

  List<BoxShadow> get shadowSmall => [
        BoxShadow(
          color: shadowColor.withValues(alpha: 0.06),
          offset: const Offset(0, 2),
          blurRadius: 4,
        ),
      ];

  List<BoxShadow> get shadowBase => [
        BoxShadow(
          color: shadowColor.withValues(alpha: 0.10),
          offset: const Offset(0, 3),
          blurRadius: 10,
        ),
      ];

  List<BoxShadow> get shadowLarge => [
        BoxShadow(
          color: shadowColor.withValues(alpha: 0.14),
          offset: const Offset(0, 8),
          blurRadius: 24,
        ),
      ];

  @override
  AnimalThemeData copyWith({
    Color? primaryColor,
    Color? primaryHoverColor,
    Color? primaryActiveColor,
    Color? primaryBackgroundColor,
    Color? successColor,
    Color? warningColor,
    Color? errorColor,
    Color? textColor,
    Color? secondaryTextColor,
    Color? disabledTextColor,
    Color? borderColor,
    Color? borderHoverColor,
    Color? lightBorderColor,
    Color? backgroundColor,
    Color? secondaryBackgroundColor,
    Color? disabledBackgroundColor,
    Color? shadowColor,
    String? fontFamily,
    String? fontPackage,
    double? borderWidth,
    double? radiusSmall,
    double? radius,
    double? radiusLarge,
    double? heightSmall,
    double? height,
    double? heightLarge,
  }) {
    return AnimalThemeData(
      primaryColor: primaryColor ?? this.primaryColor,
      primaryHoverColor: primaryHoverColor ?? this.primaryHoverColor,
      primaryActiveColor: primaryActiveColor ?? this.primaryActiveColor,
      primaryBackgroundColor:
          primaryBackgroundColor ?? this.primaryBackgroundColor,
      successColor: successColor ?? this.successColor,
      warningColor: warningColor ?? this.warningColor,
      errorColor: errorColor ?? this.errorColor,
      textColor: textColor ?? this.textColor,
      secondaryTextColor: secondaryTextColor ?? this.secondaryTextColor,
      disabledTextColor: disabledTextColor ?? this.disabledTextColor,
      borderColor: borderColor ?? this.borderColor,
      borderHoverColor: borderHoverColor ?? this.borderHoverColor,
      lightBorderColor: lightBorderColor ?? this.lightBorderColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      secondaryBackgroundColor:
          secondaryBackgroundColor ?? this.secondaryBackgroundColor,
      disabledBackgroundColor:
          disabledBackgroundColor ?? this.disabledBackgroundColor,
      shadowColor: shadowColor ?? this.shadowColor,
      fontFamily: fontFamily ?? this.fontFamily,
      fontPackage: fontPackage ?? this.fontPackage,
      borderWidth: borderWidth ?? this.borderWidth,
      radiusSmall: radiusSmall ?? this.radiusSmall,
      radius: radius ?? this.radius,
      radiusLarge: radiusLarge ?? this.radiusLarge,
      heightSmall: heightSmall ?? this.heightSmall,
      height: height ?? this.height,
      heightLarge: heightLarge ?? this.heightLarge,
    );
  }

  @override
  AnimalThemeData lerp(ThemeExtension<AnimalThemeData>? other, double t) {
    if (other is! AnimalThemeData) {
      return this;
    }

    return AnimalThemeData(
      primaryColor: Color.lerp(primaryColor, other.primaryColor, t)!,
      primaryHoverColor:
          Color.lerp(primaryHoverColor, other.primaryHoverColor, t)!,
      primaryActiveColor:
          Color.lerp(primaryActiveColor, other.primaryActiveColor, t)!,
      primaryBackgroundColor:
          Color.lerp(primaryBackgroundColor, other.primaryBackgroundColor, t)!,
      successColor: Color.lerp(successColor, other.successColor, t)!,
      warningColor: Color.lerp(warningColor, other.warningColor, t)!,
      errorColor: Color.lerp(errorColor, other.errorColor, t)!,
      textColor: Color.lerp(textColor, other.textColor, t)!,
      secondaryTextColor:
          Color.lerp(secondaryTextColor, other.secondaryTextColor, t)!,
      disabledTextColor:
          Color.lerp(disabledTextColor, other.disabledTextColor, t)!,
      borderColor: Color.lerp(borderColor, other.borderColor, t)!,
      borderHoverColor:
          Color.lerp(borderHoverColor, other.borderHoverColor, t)!,
      lightBorderColor:
          Color.lerp(lightBorderColor, other.lightBorderColor, t)!,
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      secondaryBackgroundColor: Color.lerp(
          secondaryBackgroundColor, other.secondaryBackgroundColor, t)!,
      disabledBackgroundColor: Color.lerp(
          disabledBackgroundColor, other.disabledBackgroundColor, t)!,
      shadowColor: Color.lerp(shadowColor, other.shadowColor, t)!,
      fontFamily: t < 0.5 ? fontFamily : other.fontFamily,
      fontPackage: t < 0.5 ? fontPackage : other.fontPackage,
      borderWidth: _lerpDouble(borderWidth, other.borderWidth, t),
      radiusSmall: _lerpDouble(radiusSmall, other.radiusSmall, t),
      radius: _lerpDouble(radius, other.radius, t),
      radiusLarge: _lerpDouble(radiusLarge, other.radiusLarge, t),
      heightSmall: _lerpDouble(heightSmall, other.heightSmall, t),
      height: _lerpDouble(height, other.height, t),
      heightLarge: _lerpDouble(heightLarge, other.heightLarge, t),
    );
  }
}

class AnimalTheme extends StatelessWidget {
  const AnimalTheme({
    super.key,
    required this.child,
    this.data,
  });

  final Widget child;
  final AnimalThemeData? data;

  static AnimalThemeData of(BuildContext context) {
    return Theme.of(context).extension<AnimalThemeData>() ??
        AnimalThemeData.fallback();
  }

  @override
  Widget build(BuildContext context) {
    final baseTheme = Theme.of(context);
    final animalTheme = data ?? AnimalThemeData.fallback();
    final extensions = List<ThemeExtension<dynamic>>.of(
      baseTheme.extensions.values
          .where((extension) => extension is! AnimalThemeData),
    )..add(animalTheme);

    return Theme(
      data: baseTheme.copyWith(
        colorScheme: baseTheme.colorScheme.copyWith(
          primary: animalTheme.primaryColor,
          error: animalTheme.errorColor,
          surface: animalTheme.backgroundColor,
        ),
        scaffoldBackgroundColor: animalTheme.backgroundColor,
        textTheme: baseTheme.textTheme.apply(
          bodyColor: animalTheme.textColor,
          displayColor: animalTheme.textColor,
          fontFamily: animalTheme.fontFamily,
        ),
        extensions: extensions,
      ),
      child: DefaultTextStyle.merge(
        style: animalTheme.textStyle(),
        child: child,
      ),
    );
  }
}

double _lerpDouble(double a, double b, double t) => a + (b - a) * t;
