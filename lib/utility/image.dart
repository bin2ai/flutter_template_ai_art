import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

Future<Uint8List?> selectImage() async {
  try {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    Uint8List? imageData = await image?.readAsBytes();
    return imageData;
  } catch (e) {
    throw Exception(e.toString());
  }
}

Uint8List removeImage() {
  try {
    Uint8List imageData = Uint8List.fromList([]);
    return imageData;
  } catch (e) {
    throw Exception(e.toString());
  }
}
