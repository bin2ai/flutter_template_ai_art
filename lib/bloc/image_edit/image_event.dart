part of 'image_bloc.dart';

abstract class ImageEvent extends Equatable {
  const ImageEvent();

  @override
  List<Object> get props => [];
}

class EventInitialImage extends ImageEvent {}

class EventSelectImage extends ImageEvent {}

class EventRemoveImage extends ImageEvent {}
