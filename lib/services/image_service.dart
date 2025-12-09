import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class ImageService {
  final ImagePicker _picker = ImagePicker();

  Future<String?> pickImageFromGallery() async {
    // На web и десктопах с image_picker обычно грустно,
    // поэтому просто ничего не делаем
    if (kIsWeb) return null;
    if (!(Platform.isAndroid || Platform.isIOS)) {
      return null;
    }

    final XFile? file = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );

    return file?.path;
  }
}
