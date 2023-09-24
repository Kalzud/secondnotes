import 'dart:async';

import 'package:flutter/material.dart';
import 'package:secondnotes/helpers/loading/loading_screen_controller.dart';

class LoadingScreen {
  //singleton
  static final LoadingScreen _shared = LoadingScreen._sharedInstance();
  LoadingScreen._sharedInstance();
  factory LoadingScreen() => _shared;

  LoadingScreenController? controller;

  LoadingScreenController showOverlay({
    required BuildContext context,
    required String text,
  }) {
    final _text = StreamController<String>();
    _text.add(text);

    final state = Overlay.of(context);
  }
}
