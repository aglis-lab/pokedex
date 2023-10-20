import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

class CachedPallete {
  static final CachedPallete _singleton = CachedPallete._internal();
  factory CachedPallete() {
    return _singleton;
  }
  CachedPallete._internal();

  //
  Map<String, PaletteGenerator> _palletes = {};

  Future<PaletteGenerator> generateFromImageProvier(
      String key, ImageProvider<Object> imageProvider) async {
    if (_palletes.containsKey(key)) {
      return _palletes[key]!;
    }
    final pallete = await PaletteGenerator.fromImageProvider(imageProvider);
    _palletes[key] = pallete;

    return pallete;
  }
}
