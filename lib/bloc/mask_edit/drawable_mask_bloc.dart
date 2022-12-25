import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../data/repos/ai_art_repo.dart';
part 'drawable_mask_event.dart';
part 'drawable_mask_state.dart';

class DrawableMaskBloc extends Bloc<DrawableMaskEvent, DrawableMaskState> {
  AiArtRepo drawableMaskRepo = AiArtRepo();

  DrawableMaskBloc() : super(StateMaskInitial()) {
    on<DrawableMaskInitialEvent>((event, emit) {
      drawableMaskRepo.isMaskVisible = false;
      emit(StateMaskInitial());
    });

    on<DrawableMaskContinuePathEvent>((event, emit) {
      //event created change in localPosition, not brushSize
      try {
        emit(const StateMaskProcessing());
        drawableMaskRepo.maskContinuePath(
            localPosition: event.localPosition,
            brushSize: drawableMaskRepo.brushSize);
        emit(StateMaskLoaded(drawableMaskRepo));
      } catch (e) {
        emit(StateMaskError(e.toString()));
      }
    });

    on<DrawableMaskFinishPathEvent>((event, emit) {
      try {
        emit(const StateMaskProcessing());
        drawableMaskRepo.maskFinishPath();
        emit(StateMaskLoaded(drawableMaskRepo));
      } catch (e) {
        emit(StateMaskError(e.toString()));
      }
    });

    on<DrawableMaskUndoEvent>((event, emit) {
      try {
        emit(const StateMaskProcessing());
        drawableMaskRepo.maskUndo();
        emit(StateMaskLoaded(drawableMaskRepo));
      } catch (e) {
        emit(StateMaskError(e.toString()));
      }
    });

    on<DrawableMaskRedoEvent>((event, emit) {
      try {
        emit(const StateMaskProcessing());
        drawableMaskRepo.maskRedo();
        emit(StateMaskLoaded(drawableMaskRepo));
      } catch (e) {
        emit(StateMaskError(e.toString()));
      }
    });

    on<DrawableMaskClearEvent>((event, emit) {
      try {
        emit(const StateMaskProcessing());
        drawableMaskRepo
          ..maskClear()
          ..updateMaskCanvas();
        emit(StateMaskLoaded(drawableMaskRepo));
      } catch (e) {
        emit(StateMaskError(e.toString()));
      }
    });

    on<DrawableMaskBrushSizeChangedEvent>((event, emit) {
      try {
        emit(const StateMaskProcessing());
        drawableMaskRepo.setBrushSize(event.brushSize);
        emit(StateMaskLoaded(drawableMaskRepo));
      } catch (e) {
        emit(StateMaskError(e.toString()));
      }
    });

    on<DrawableMaskVisibilityToggledEvent>((event, emit) {
      try {
        emit(const StateMaskProcessing());
        drawableMaskRepo.toggleVisibility();
        emit(StateMaskLoaded(drawableMaskRepo));
      } catch (e) {
        emit(StateMaskError(e.toString()));
      }
    });
  }
}
