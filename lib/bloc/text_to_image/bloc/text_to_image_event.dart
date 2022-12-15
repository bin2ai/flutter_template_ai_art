part of 'text_to_image_bloc.dart';

abstract class TextToImageEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class TextToImageGenerate extends TextToImageEvent {
  final String prompt;

  TextToImageGenerate({required this.prompt});
}

class TextToImageEdit extends TextToImageEvent {
  final String prompt;
  final Image image;

  TextToImageEdit({required this.prompt, required this.image});
}

class TextToImageVary extends TextToImageEvent {
  final Image image;

  TextToImageVary({required this.image});
}
