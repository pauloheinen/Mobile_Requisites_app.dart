import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';

class ImageUtil {
  static Future<String?> accessGalleryAndReturnB64Image() async {
    XFile? recordedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (recordedImage == null) {
      return null;
    }
    String path = recordedImage.path;

    return base64Encode(File(path).readAsBytesSync());
  }

  static Future<String?> accessCameraAndReturnB64Image() async {
    XFile? recordedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (recordedImage == null) {
      return null;
    }
    String path = recordedImage.path;

    GallerySaver.saveImage(path);

    return base64Encode(File(path).readAsBytesSync());
  }

  static provideImageFromPath(String imageInB64) {
    return Image.memory(const Base64Decoder().convert(imageInB64)).image;
  }
}
