import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../utility/image.dart';
import '../utility/theme.dart';

class ImageEditPage extends StatefulWidget {
  const ImageEditPage({Key? key}) : super(key: key);
  @override
  _ImageEditPageState createState() => _ImageEditPageState();
}

class _ImageEditPageState extends State<ImageEditPage> {
  ColorMode bgColorMode = ColorMode.dark;

  Uint8List selectedImageData = Uint8List.fromList([]);
  Uint8List maskImageData = resetMask(512, 512);
  List<Path> paths = [];
  Path currentPath = Path();
  int currentPathIndex = -1;
  double brushSize = 20;
  Color colorUndo = Colors.grey;
  Color colorRedo = Colors.grey;
  final TextEditingController _textController = TextEditingController();
  String promptText = '';

  @override
  void initState() {
    super.initState();
    colorUndo = Colors.grey;
    colorRedo = Colors.grey;
  }

  /*details can be either type DragStartDetails or DragUpdateDetails or DragDownDetails*/
  void _maskContinuePath(dynamic details) {
    currentPath.addOval(
        Rect.fromCircle(center: details.localPosition, radius: brushSize));
    setState(() {});
  }

  void _maskFinishPath() {
    paths = paths.sublist(0, currentPathIndex + 1);
    paths.add(Path.from(currentPath));
    currentPathIndex = paths.length - 1;
    currentPath.reset();
    colorUndo = Colors.blue;
    colorRedo = Colors.grey;
    setState(() {});
  }

  void _maskUndo() {
    if (currentPathIndex >= 0) {
      currentPathIndex--;
      currentPath.reset();
      currentPathIndex < paths.length - 1
          ? colorRedo = Colors.blue
          : Colors.grey;
    }
    currentPathIndex <= 0 ? colorUndo = Colors.grey : Colors.blue;
    setState(() {});
  }

  void _maskRedo() {
    if (currentPathIndex < paths.length - 1) {
      currentPathIndex++;
      colorUndo = Colors.blue;
    }
    currentPathIndex >= paths.length - 1
        ? colorRedo = Colors.grey
        : Colors.blue;
    setState(() {});
  }

  void _maskClear() {
    paths.clear();
    currentPath.reset();
    currentPathIndex = -1;
    colorUndo = Colors.grey;
    colorRedo = Colors.grey;
    setState(() {});
  }

  // function to select image from gallery or camera
  void _selectImage() async {
    // Prompt the user to select an image from the device's gallery
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    // Read the image data into a Uint8List
    Uint8List? imageData = await image?.readAsBytes();
    setState(() {
      selectedImageData = imageData!;
    });
  }

  void _removeImage() {
    selectedImageData = Uint8List.fromList([]);
    setState(() {});
  }

  void _submit() {
    //todo: save image
  }

  Future<void> _saveMask() async {
    maskImageData = await saveMask(paths);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: 512,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 100,
              //dark mode
              color: getBgColor(bgColorMode),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    onPressed:
                        selectedImageData.isEmpty ? _selectImage : _removeImage,
                    child: selectedImageData.isEmpty
                        ? const Text('Select Image')
                        : const Text('Remove Image'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorUndo,
                    ),
                    onPressed: _maskUndo,
                    child: const Text('Undo'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorRedo,
                    ),
                    onPressed: _maskRedo,
                    child: const Text('Redo'),
                  ),
                  ElevatedButton(
                    onPressed: _maskClear,
                    child: const Text('Clear'),
                  ),
                  ElevatedButton(
                      onPressed: _saveMask, child: const Text('Mask')),
                ],
              ),
            ),
            Container(
              color: getBgColor(bgColorMode),
              height: 100,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      width: brushSize,
                      height: brushSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[850],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Slider(
                      value: brushSize,
                      min: 1,
                      max: 50,
                      divisions: 49,
                      label: brushSize.round().toString(),
                      onChanged: (double value) {
                        setState(() {
                          brushSize = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: 512,
                height: 512,
                color: getBgColor(bgColorMode),
                child: SingleChildScrollView(
                  child: Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: selectedImageData.isEmpty
                              ? Container()
                              : Image.memory(
                                  selectedImageData,
                                  width: 512,
                                  height: 512,
                                ),
                        ),
                      ),
                      SizedBox(
                        height: 512,
                        width: 512,
                        child: CustomPaint(
                            willChange: true,
                            painter: DrawingPainter(
                                paths.sublist(0, currentPathIndex + 1),
                                brushSize)),
                      ),
                      SizedBox(
                        height: 512,
                        width: 512,
                        child: GestureDetector(
                          onPanStart: (DragStartDetails details) =>
                              _maskContinuePath(details),
                          onPanUpdate: (DragUpdateDetails details) =>
                              _maskContinuePath(details),
                          onPanEnd: (DragEndDetails details) =>
                              _maskFinishPath(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            //row with textfield (prompt) and submit button
            Container(
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              height: 100,
              color: getBgColor(bgColorMode),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(
                    width: 300,
                    child: TextField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Prompt',
                      ),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: _submit, child: const Text("Submit"))
                ],
              ),
            ),
            //show mask image
            Image.memory(
              maskImageData,
              fit: BoxFit.contain,
              width: 50,
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
