import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_template_ai_art/utility/mask.dart';

class AiArtRepo {
  double brushSize = 20;
  List<Uint8List> points = [];
  Path currentPath = Path();
  List<Path> paths = [];
  int currentPathIndex = -1;
  MaterialColor colorUndo = Colors.grey;
  MaterialColor colorRedo = Colors.grey;
  String promptText = '';
  late CustomPainter painter = MaskPainter([], brushSize);
  bool isMaskVisible = false;

  void maskContinuePath(
      {required Offset localPosition, required double brushSize}) {
    try {
      currentPath
          .addOval(Rect.fromCircle(center: localPosition, radius: brushSize));
      updateMaskCanvas();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  void maskFinishPath() {
    try {
      paths = paths.sublist(0, currentPathIndex + 1);
      paths.add(Path.from(currentPath));
      currentPathIndex = paths.length - 1;
      currentPath.reset();
      colorUndo = Colors.blue;
      colorRedo = Colors.grey;
      updateMaskCanvas();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  void maskUndo() {
    try {
      if (currentPathIndex >= 0) {
        currentPathIndex--;
        currentPath.reset();
        currentPathIndex < paths.length - 1
            ? colorRedo = Colors.blue
            : Colors.grey;
      }
      currentPathIndex <= 0 ? colorUndo = Colors.grey : Colors.blue;
      updateMaskCanvas();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  void maskRedo() {
    try {
      if (currentPathIndex < paths.length - 1) {
        currentPathIndex++;
        colorUndo = Colors.blue;
      }
      currentPathIndex >= paths.length - 1
          ? colorRedo = Colors.grey
          : Colors.blue;
      updateMaskCanvas();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  void maskClear() {
    try {
      paths.clear();
      currentPath.reset();
      currentPathIndex = -1;
      colorUndo = Colors.grey;
      colorRedo = Colors.grey;
      updateMaskCanvas();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  String setPromptText(String text) {
    try {
      promptText = text;
      return promptText;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  void updateMaskCanvas() {
    try {
      //sub path of 0 to current path index
      painter = MaskPainter(paths.sublist(0, currentPathIndex + 1), brushSize);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  void setBrushSize(double size) {
    try {
      brushSize = size;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  void toggleVisibility() {
    try {
      isMaskVisible = !isMaskVisible;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
