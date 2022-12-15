part of 'text_to_image_bloc.dart';

@immutable
abstract class TextToImageState extends Equatable {}

class TextToImageInitial extends TextToImageState {
  @override
  List<Object?> get props => [];
}

class TextToImageLoading extends TextToImageState {
  @override
  List<Object?> get props => [];
}

class TextToImageLoaded extends TextToImageState {
  final List<Image> images;

  TextToImageLoaded({required this.images});

  @override
  List<Object?> get props => [images];
}

class TextToImageError extends TextToImageState {
  final String message;

  TextToImageError({required this.message});
  @override
  List<Object?> get props => [message];
}
