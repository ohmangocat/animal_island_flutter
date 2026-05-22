import 'dart:async';
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

class MobilePreviewEmbed extends StatelessWidget {
  const MobilePreviewEmbed({
    super.key,
    required this.source,
  });

  final String source;

  static final Set<String> _registeredViewTypes = <String>{};

  @override
  Widget build(BuildContext context) {
    final viewType = 'animal-mobile-preview-${source.hashCode}';
    if (_registeredViewTypes.add(viewType)) {
      ui_web.platformViewRegistry.registerViewFactory(viewType, (viewId) {
        final iframe = web.HTMLIFrameElement()
          ..title = 'Animal Island mobile preview'
          ..allow = 'clipboard-read; clipboard-write';

        iframe.style
          ..setProperty('border', '0')
          ..setProperty('width', '100%')
          ..setProperty('height', '100%')
          ..setProperty('overflow', 'hidden')
          ..setProperty('border-radius', '34px')
          ..setProperty('clip-path', 'inset(0 round 34px)')
          ..setProperty('background', '#F8F4E8')
          ..setProperty('display', 'block');
        iframe.setAttribute('loading', 'eager');
        Timer.run(() {
          iframe.src = source;
        });
        return iframe;
      });
    }
    return HtmlElementView(viewType: viewType);
  }
}
