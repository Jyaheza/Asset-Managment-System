import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

ImageProvider<Object> convertToImage(String path) {
  if (kIsWeb) {
    return NetworkImage('assets/$path');
  }
  return AssetImage(path);
}
