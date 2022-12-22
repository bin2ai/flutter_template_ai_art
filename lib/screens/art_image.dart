import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

// custom painter class to draw the paths on the canvas
class DrawingPainter extends CustomPainter {
  DrawingPainter(this.paths, this.isCreate) {
    //create a canvas to draw on, and a picture recorder to record the canvas
    recorder = PictureRecorder();
    canvas = Canvas(recorder);
  }

  final List<Path> paths;
  bool isCreate;
  late Canvas canvas;
  late PictureRecorder recorder;

  @override
  void paint(Canvas canvas, Size size) {
    // draw each path in the list
    for (final path in paths) {
      //if path is outside canvas, clip it
      canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
      canvas.drawPath(
          path, Paint()..color = isCreate ? Colors.black : Colors.white);
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}

class ImageEditPage extends StatefulWidget {
  const ImageEditPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ImageEditPageState createState() => _ImageEditPageState();
}

//create image mask full of white pixels and size w,h
Uint8List resetMask(int w, int h) {
  final mask = Uint8List(w * h * 4);
  for (var i = 0; i < mask.length; i += 4) {
    mask[i] = 255; //red
    mask[i + 1] = 255; //green
    mask[i + 2] = 255; //blue
    mask[i + 3] = 255; //alpha
  }

  // Encode the image data in JPEG format
  return img.encodeJpg(img.Image.fromBytes(w, h, mask)) as Uint8List;
}

class _ImageEditPageState extends State<ImageEditPage> {
  Uint8List selectedImageData = Uint8List(0);
  Uint8List maskImageData = resetMask(512, 512);
  String promptText = '';
  bool _maskVisibility = false;
  bool _maskMode = false;

  List<Offset> points = <Offset>[];

  Offset currentPosition = Offset.zero;

  List<Path> paths = [];
  Path currentPath = Path();
  int currentPathIndex = -1;

  Color colorUndo = Colors.grey;
  Color colorRedo = Colors.grey;

  int lenSubPaths = 0;
  int lenPaths = 0;

/*details can be either type DragStartDetails or DragUpdateDetails or DragDownDetails*/
  void _addOval(dynamic details) {
    setState(() {
      currentPath
          .addOval(Rect.fromCircle(center: details.localPosition, radius: 10));
    });
  }

  void _updatePath() {
    setState(() {
      paths = paths.sublist(0, currentPathIndex + 1);
      paths.add(Path.from(currentPath));
      currentPath.reset();
      currentPathIndex = paths.length - 1;
      colorUndo = Colors.black;
      colorRedo = Colors.grey;
    });
  }

  void _undoPath() {
    setState(() {
      if (paths.isNotEmpty && currentPathIndex >= 0) {
        currentPathIndex--;
        colorUndo = currentPathIndex == 0 ? Colors.black : Colors.grey;
        colorRedo = Colors.black;
      }
    });
  }

  void _redoPath() {
    setState(() {
      if (paths.isNotEmpty && currentPathIndex < paths.length - 1) {
        currentPathIndex++;
        colorRedo =
            currentPathIndex == paths.length - 1 ? Colors.grey : Colors.black;
      }
    });
  }

  void _toggleMaskVisibility() {
    setState(() {
      _maskVisibility = !_maskVisibility;
    });
  }

  void _toggleMaskMode() {
    setState(() {
      _maskMode = !_maskMode; //create or erase
    });
  }

  void _clearImage() {
    setState(() {
      selectedImageData = Uint8List(0);
    });
  }

  void _clearMask() {
    setState(() {
      points.clear();
      paths.clear();
      currentPath.reset();
      currentPathIndex = -1;
      colorUndo = Colors.grey;
      colorRedo = Colors.grey;
    });
  }

  void _selectImage() async {
    // Prompt the user to select an image from the device's gallery
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    // Read the image data into a Uint8List
    Uint8List? imageData = await image?.readAsBytes();
    setState(() {
      // Update the _selectedImageData variable with the selected image data
      selectedImageData = imageData!;
    });
  }

  SizedBox _buildButton(String text,
      {required VoidCallback onPressed, required Widget icon}) {
    return SizedBox(
      width: 150,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: Text(text)),
            Expanded(child: icon),
          ],
        ),
      ),
    );
  }

  //bloc builder
  @override
  Widget build(BuildContext context) {
    //point collection length, points length, print

    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Edit'),
      ),
      body:
          //scrollable column
          SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      //Image options Title
                      const Text(
                        'Image Options',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      _buildButton('Select',
                          onPressed: _selectImage,
                          icon: const Icon(Icons.image)),
                      _buildButton('Reset',
                          onPressed: _clearImage,
                          icon: const Icon(Icons.delete)),
                      _buildButton('Edit',
                          onPressed: () {}, icon: const Icon(Icons.edit)),
                      _buildButton('Vary',
                          onPressed: () {}, icon: const Icon(Icons.refresh)),
                      _buildButton('Expand',
                          onPressed: () {}, icon: const Icon(Icons.add)),
                    ],
                  ),
                ),
                //padding
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      selectedImageData.isNotEmpty
                          //if image is selected, show stack of image and mask
                          ? SizedBox(
                              width: 512,
                              child: Stack(
                                fit: StackFit.loose,
                                children: [
                                  SizedBox(
                                    width: 512,
                                    child: Image.memory(selectedImageData),
                                  ),
                                  //if mask is on, show mask
                                  _maskVisibility
                                      ? SizedBox(
                                          width: 512,
                                          child: Opacity(
                                            opacity: 0.5,
                                            child: Image.memory(
                                              maskImageData,
                                              // Animation<double> to animate the opacity
                                            ),
                                          ),
                                        )
                                      : Container(
                                          width: 512,
                                          height: 512,
                                          color: Colors.transparent,
                                        ),
                                  // Wrap the CustomPaint widget in a Positioned widget
                                  // to position it over the image
                                  Positioned(
                                    top: 0,
                                    left: 0,
                                    right: 0,
                                    bottom: 0,
                                    child: SizedBox(
                                      width: 512,
                                      child: GestureDetector(
                                        //DragUpdateDetails
                                        onPanUpdate: (details) =>
                                            _addOval(details),
                                        //DragDownDetails
                                        onPanDown: (details) =>
                                            _addOval(details),
                                        // // DragStartDetails
                                        // onPanStart: (details) =>
                                        //     _addOval(details),
                                        onPanEnd: (details) {
                                          _updatePath();
                                        },
                                        child: SizedBox(
                                          width: 512,
                                          height: 512,
                                          child: CustomPaint(
                                            size: Size.infinite,
                                            painter: DrawingPainter(
                                              currentPathIndex >= 0
                                                  ? paths.sublist(
                                                      0, currentPathIndex + 1)
                                                  : [],
                                              _maskMode,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container(
                              width: 512,
                              height: 512,
                              color: Colors.grey,
                              child: const Center(
                                child: Text('No image selected'),
                              ),
                            ),
                      SizedBox(
                        width: 512,
                        child: Row(
                          children: [
                            const Expanded(child: Text('Mask Mode:')),
                            Expanded(
                              child: Tooltip(
                                message: _maskMode ? 'Show Mask' : 'Hide Mask',
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey,
                                  ),
                                  onPressed: _toggleMaskVisibility,
                                  child: Icon(_maskVisibility
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                ),
                              ),
                            ),
                            //undo last mask edit
                            Expanded(
                              child: Tooltip(
                                message: 'Undo Mask Edit',
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: colorUndo,
                                  ),
                                  onPressed:
                                      // undoStack.isEmpty ? null : _undoPath,
                                      _undoPath,
                                  child: const Icon(Icons.undo),
                                ),
                              ),
                            ),
                            //redo last mask edit
                            Expanded(
                              child: Tooltip(
                                message: 'Redo Mask Edit',
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: colorRedo,
                                  ),
                                  onPressed: _redoPath,
                                  child: const Icon(Icons.redo),
                                ),
                              ),
                            ),
                            Expanded(
                              //wrap button with tool tip
                              child: Tooltip(
                                message: _maskMode
                                    ? 'Add to Mask'
                                    : 'Erase from Image',
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey,
                                  ),
                                  onPressed: _toggleMaskMode,
                                  child: Icon(Icons.create,
                                      color: _maskMode
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Tooltip(
                                message: 'Clear Mask',
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey,
                                  ),
                                  onPressed: _clearMask,
                                  child: const Icon(Icons.refresh),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            //print length current path and paths
            Text('index = $currentPathIndex, paths = ${paths.length}'),
          ],
        ),
      ),
    );
  }
}
