import 'dart:math';
import 'package:flutter/widgets.dart';

class TextToImageRepo {
  Future<List<Image>> generate({required String prompt}) async {
    try {
      return await tempFunction();
    } catch (e, s) {
      print(e);
      print(s);

      return [];
    }
  }

  Future<List<Image>> edit(
      {required Image image, required String prompt}) async {
    try {
      return await tempFunction();
    } catch (e, s) {
      print(e);
      print(s);
      return [];
    }
  }

  Future<List<Image>> vary({required Image image}) async {
    try {
      return await tempFunction();
    } catch (e, s) {
      print(e);
      print(s);
      return [];
    }
  }

  Future<List<Image>> tempFunction() async {
    //image url
    String url = "https://picsum.photos/300/300";
    //random number from 1 to 10;
    int randomNumber = Random().nextInt(10) + 1;
    //wait random number of seconds
    await Future.delayed(Duration(seconds: randomNumber));
    //http download image

    //image memory from bytes
    List<Image> images = [];
    for (int i = 0; i < randomNumber; i++) {
      images.add(Image.network(url));
    }
    return images;
  }
}
