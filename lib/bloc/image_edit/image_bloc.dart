import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../utility/image.dart';

part 'image_event.dart';
part 'image_state.dart';

class ImageSelectBloc extends Bloc<ImageEvent, ImageSelectState> {
  Uint8List? image = Uint8List(0);

  ImageSelectBloc() : super(StateSelectImageInitial()) {
    on<EventInitialImage>((event, emit) {
      emit(StateSelectImageInitial());
    });

    on<EventSelectImage>((event, emit) async {
      try {
        image = await selectImage();
        if (image != null) {
          emit(StateSelectImageLoaded(image!));
        } else {
          emit(StateSelectImageInitial());
        }
      } catch (e) {
        // emit(StateSelectImageError(message: e.toString()));

        emit(StateSelectImageInitial());
      }
    });

    on<EventRemoveImage>((event, emit) async {
      image = null;
      emit(StateSelectImageInitial());
    });
  }
}
