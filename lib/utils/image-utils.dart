import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:exif/exif.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_crop/image_crop.dart';

class ImageProcessor {
  static Future<String> getBase64(String imagePath) async {
    final file = File(imagePath);
    var fileBytes = await file.readAsBytes();
    return base64Encode(fileBytes);
  }

  static Future<File> cropByArea(String srcFilePath, Rect? area) async {
    final originalFile = File(srcFilePath);

    /*final sampledFile = await ImageCrop.sampleImage(
      file: widget.image,
      preferredSize: (2000 / scale).round(),
    );*/

    if (area != null) {
      final croppedFile = await ImageCrop.cropImage(file: originalFile, area: area);
      return croppedFile;
    } else {
      return originalFile;
    }
  }

  static Future<String> getBase64ResizedImage(String srcFilePath, int width, int height) async {
    final originalFile = File(srcFilePath);

    img.Image? src = img.decodeImage(originalFile.readAsBytesSync());

    if (src != null) {
      img.Image destImage = img.copyResize(src, width: width, height: height);
      var encodedImage = img.encodeJpg(destImage);
      return base64Encode(encodedImage);
    } else {
      return '';
    }
  }

  static Future<void> fixImageRotation(String srcFilePath) async {
    final originalFile = File(srcFilePath);

    img.Image? src = img.decodeImage(originalFile.readAsBytesSync());

    if (src != null) {
      img.Image destImage = img.bakeOrientation(src);
      var png = img.encodeJpg(destImage);
      await File(srcFilePath).writeAsBytes(png);
    }
  }

  static Future<String> cropSquare(String srcFilePath) async {
    final originalFile = File(srcFilePath);

    img.Image? src = img.decodeImage(originalFile.readAsBytesSync());

    if (src != null) {
      var cropSize = min(src.width, src.height);
      int offsetX = (src.width - min(src.width, src.height)) ~/ 2;
      int offsetY = (src.height - min(src.width, src.height)) ~/ 2;
      img.Image destImage = img.copyCrop(src, offsetX, offsetY, cropSize, cropSize);
      img.Image rotatedImg = img.copyRotate(destImage, 90);
      var png = img.encodePng(rotatedImg);
      return base64Encode(png);
    } else {
      return '';
    }
  }

  static Future<File> fixExifRotation(String imagePath) async {
    final originalFile = File(imagePath);
    List<int> imageBytes = await originalFile.readAsBytes();

    final originalImage = img.decodeImage(imageBytes);
    if (originalImage != null) {
      final height = originalImage.height;
      final width = originalImage.width;

      if (height >= width) {
        return originalFile;
      }

      final exifData = await readExifFromBytes(imageBytes);

      late img.Image fixedImage;

      if (height < width) {
        if (exifData['Image Orientation']!.printable!.contains('Horizontal')) {
          fixedImage = img.copyRotate(originalImage, 90);
        } else if (exifData['Image Orientation']!.printable!.contains('180')) {
          fixedImage = img.copyRotate(originalImage, -90);
        } else {
          fixedImage = img.copyRotate(originalImage, 0);
        }
      }

      final fixedFile = await originalFile.writeAsBytes(img.encodeJpg(fixedImage));

      return fixedFile;
    } else {
      return originalFile;
    }
  }
}
