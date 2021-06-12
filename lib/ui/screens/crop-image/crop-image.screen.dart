import 'dart:io';

import 'package:ai_way/locator.dart';
import 'package:ai_way/services/capture.service.dart';
import 'package:flutter/material.dart';
import 'package:image_crop/image_crop.dart';

class CropImageScreen extends StatefulWidget {
  final File image;

  CropImageScreen({Key? key, required this.image}) : super(key: key);

  @override
  _CropImageScreenState createState() {
    return _CropImageScreenState();
  }
}

class _CropImageScreenState extends State<CropImageScreen> {
  final GlobalKey<CropState> cropKey = GlobalKey<CropState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: [
            Expanded(
              child: Crop(
                key: cropKey,
                image: FileImage(widget.image),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 22.0),
              child: ElevatedButton(
                child: Text(
                  'Conferma',
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  textStyle: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700),
                ),
                onPressed: () async {
                  locator<CaptureService>().captureArea = cropKey.currentState!.area;
                  Navigator.of(context).pop();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
