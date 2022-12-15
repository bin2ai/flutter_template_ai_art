// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_template_ai_art/data/repos/text_to_image_repo.dart';

part 'text_to_image_event.dart';
part 'text_to_image_state.dart';

class TextToImageBloc extends Bloc<TextToImageEvent, TextToImageState> {
  final TextToImageRepo textToImageRepo;
  List<Image> images = [];

  TextToImageBloc({required this.textToImageRepo})
      : super(TextToImageInitial()) {
    on<TextToImageGenerate>((event, emit) async {
      emit(TextToImageLoading());
      try {
        images = await textToImageRepo.generate(prompt: event.prompt);
        emit(TextToImageLoaded(images: images));
      } catch (e) {
        emit(TextToImageError(message: e.toString()));
        emit(TextToImageInitial());
      }
    });

    on<TextToImageEdit>((event, emit) async {
      emit(TextToImageLoading());
      try {
        images = await textToImageRepo.edit(
            image: event.image, prompt: event.prompt);
        emit(TextToImageLoaded(images: images));
      } catch (e) {
        emit(TextToImageError(message: e.toString()));
        emit(TextToImageInitial());
      }
    });

    on<TextToImageVary>((event, emit) async {
      emit(TextToImageLoading());
      try {
        images = await textToImageRepo.vary(image: event.image);
        emit(TextToImageLoaded(images: images));
      } catch (e) {
        emit(TextToImageError(message: e.toString()));
        emit(TextToImageInitial());
      }
    });
  }
}
