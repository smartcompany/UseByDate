import 'package:flutter/foundation.dart';

/// Full-screen pick flow cover (camera prep → navigation).
class PhotoPickFlowOverlay {
  const PhotoPickFlowOverlay({
    required this.show,
    required this.hide,
  });

  final void Function(String message) show;
  final VoidCallback hide;
}
