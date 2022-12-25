import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../data/repos/ai_art_repo.dart';
part 'drawable_mask_event.dart';
part 'drawable_mask_state.dart';

class DrawableMaskBloc extends Bloc<DrawableMaskEvent, DrawableMaskState> {
  AiArtRepo drawableMaskRepo = AiArtRepo();

  DrawableMaskBloc() : super(StateMaskInitial()) {
    //events:

    on<DrawableMaskInitialEvent>((event, emit) {
      print("entered DrawableMaskInitialEvent");
      drawableMaskRepo.isMaskVisible = false;

      emit(StateMaskInitial());
    });

    on<DrawableMaskContinuePathEvent>((event, emit) {
      //event created change in localPosition, not brushSize
      print("entered DrawableMaskContinuePathEvent");
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
        print("entered DrawableMaskFinishPathEvent");
        emit(const StateMaskProcessing());
        drawableMaskRepo.maskFinishPath();

        print("paths length: ${drawableMaskRepo.paths.length}");
        emit(StateMaskLoaded(drawableMaskRepo));
      } catch (e) {
        emit(StateMaskError(e.toString()));
      }
    });

    on<DrawableMaskUndoEvent>((event, emit) {
      try {
        print("entered DrawableMaskUndoEvent");
        emit(const StateMaskProcessing());
        drawableMaskRepo.maskUndo();

        emit(StateMaskLoaded(drawableMaskRepo));
        print("index: ${drawableMaskRepo.currentPathIndex}");
      } catch (e) {
        emit(StateMaskError(e.toString()));
      }
    });

    on<DrawableMaskRedoEvent>((event, emit) {
      try {
        print("entered DrawableMaskRedoEvent");
        emit(const StateMaskProcessing());
        drawableMaskRepo.maskRedo();

        print("index: ${drawableMaskRepo.currentPathIndex}");
        emit(StateMaskLoaded(drawableMaskRepo));
      } catch (e) {
        emit(StateMaskError(e.toString()));
      }
    });

    on<DrawableMaskClearEvent>((event, emit) {
      try {
        print("entered DrawableMaskClearEvent");
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
        print("entered DrawableMaskBrushSizeChangedEvent");
        emit(const StateMaskProcessing());
        drawableMaskRepo..setBrushSize(event.brushSize);

        emit(StateMaskLoaded(drawableMaskRepo));
      } catch (e) {
        emit(StateMaskError(e.toString()));
      }
    });

    on<DrawableMaskVisibilityToggledEvent>((event, emit) {
      try {
        print("entered DrawableMaskVisibilityToggledEvent");
        emit(const StateMaskProcessing());
        drawableMaskRepo.toggleVisibility();

        emit(StateMaskLoaded(drawableMaskRepo));
      } catch (e) {
        emit(StateMaskError(e.toString()));
      }
    });
  }
}
