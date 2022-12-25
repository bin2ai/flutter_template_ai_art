//create image mask full of white pixels and size w,h
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';

// custom painter class to draw the paths on the canvas
class MaskPainter extends CustomPainter {
  MaskPainter(this.paths, this.brushSize);

  final List<Path> paths;
  double brushSize;

  @override
  void paint(Canvas canvas, Size size) {
    // draw each path in the list
    for (final path in paths) {
      Paint paint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill
        ..isAntiAlias = true;
      //if path is outside canvas, clip it
      canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(MaskPainter oldDelegate) => oldDelegate.paths != paths;

  Future<Uint8List> saveMask(List<Path> paths) async {
    //cave paths from canvas to memory image
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    //make initial canvas background white
    canvas.drawRect(
        const Rect.fromLTWH(0, 0, 512, 512), Paint()..color = Colors.white);
    //setup paint
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    //draw paths
    for (var path in paths) {
      canvas.drawPath(path, paint);
    }
    final image = recorder.endRecording().toImage(512, 512);
    ByteData? pngBytes;
    //save image in memory
    await image.then((value) async {
      pngBytes = await value.toByteData(format: ImageByteFormat.png);
    });
    return pngBytes!.buffer.asUint8List();
  }
}
