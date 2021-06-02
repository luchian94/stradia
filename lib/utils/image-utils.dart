import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:exif/exif.dart';
import 'package:image/image.dart' as img;

class ImageProcessor {
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

      // Let's check for the image size
      if (height >= width) {
        // I'm interested in portrait photos so
        // I'll just return here
        return originalFile;
      }

      // We'll use the exif package to read exif data
      // This is map of several exif properties
      // Let's check 'Image Orientation'
      final exifData = await readExifFromBytes(imageBytes);

      late img.Image fixedImage;

      if (height < width) {
        // rotate
        if (exifData!['Image Orientation']!.printable!.contains('Horizontal')) {
          fixedImage = img.copyRotate(originalImage, 90);
        } else if (exifData['Image Orientation']!.printable!.contains('180')) {
          fixedImage = img.copyRotate(originalImage, -90);
        } else {
          fixedImage = img.copyRotate(originalImage, 0);
        }
      }

      // Here you can select whether you'd like to save it as png
      // or jpg with some compression
      // I choose jpg with 100% quality
      final fixedFile = await originalFile.writeAsBytes(img.encodeJpg(fixedImage));

      return fixedFile;
    } else {
      return originalFile;
    }
  }
}
