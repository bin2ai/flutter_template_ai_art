part of 'image_bloc.dart';

abstract class ImageSelectState extends Equatable {
  const ImageSelectState();

  @override
  List<Object> get props => [];
}

class StateSelectImageInitial extends ImageSelectState {}

class StateSelectImageLoading extends ImageSelectState {}

class StateSelectImageLoaded extends ImageSelectState {
  final Uint8List image;
  const StateSelectImageLoaded(this.image);
  @override
  List<Object> get props => [image];
}
