import 'package:flutter/material.dart';

import '../animal_theme.dart';

class AnimalCodeBlock extends StatelessWidget {
  const AnimalCodeBlock({
    super.key,
    required this.code,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
  });

  final String code;
  final EdgeInsetsGeometry padding;
  final BorderRadiusGeometry borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);

    return Container(
      width: double.infinity,
      padding: padding,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFF2B2118),
        borderRadius: borderRadius,
        border: Border.all(color: const Color(0xFF3D3028)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Text.rich(
          TextSpan(children: _highlight(code)),
          style: TextStyle(
            color: const Color(0xFFE8D5BC),
            fontFamily: 'monospace',
            fontSize: 14,
            height: 1.7,
            letterSpacing: 0,
            fontWeight: FontWeight.w600,
            shadows: [
              Shadow(
                color: theme.shadowColor.withValues(alpha: 0.25),
                offset: const Offset(0, 1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

List<TextSpan> _highlight(String code) {
  final spans = <TextSpan>[];
  final pattern = RegExp(
    r"""(".*?"|'.*?'|`[\s\S]*?`|\b(?:true|false|null|undefined|void|class|const|final|return|import|export|new|required|this|extends|Widget|BuildContext|function|async|await|type|interface)\b|//.*?$|\b\d+\.?\d*\b|[{}[\]();,]|[+\-*/%=<>!&|^~?:])""",
    multiLine: true,
  );
  var index = 0;
  for (final match in pattern.allMatches(code)) {
    if (match.start > index) {
      spans.add(TextSpan(text: code.substring(index, match.start)));
    }
    final token = match.group(0)!;
    final color = token.startsWith('//')
        ? const Color(0xFF6B5E50)
        : token.startsWith('"') ||
                token.startsWith("'") ||
                token.startsWith('`')
            ? const Color(0xFFA8D4A0)
            : RegExp(r'^\d').hasMatch(token)
                ? const Color(0xFFA8D4A0)
                : RegExp(r'^[{}[\]();,+\-*/%=<>!&|^~?:]+$').hasMatch(token)
                    ? const Color(0xFFD4B896)
                    : const Color(0xFFD4A0E0);
    spans.add(TextSpan(
      text: token,
      style: TextStyle(
        color: color,
        fontWeight: token.startsWith('//') ? FontWeight.w500 : FontWeight.w700,
      ),
    ));
    index = match.end;
  }
  if (index < code.length) {
    spans.add(TextSpan(text: code.substring(index)));
  }
  return spans;
}
