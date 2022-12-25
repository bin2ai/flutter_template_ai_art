part of 'drawable_mask_bloc.dart';

abstract class DrawableMaskEvent extends Equatable {
  const DrawableMaskEvent();

  @override
  List<Object> get props => [];
}

class DrawableMaskInitialEvent extends DrawableMaskEvent {}

class DrawableMaskContinuePathEvent extends DrawableMaskEvent {
  final Offset localPosition;
  const DrawableMaskContinuePathEvent(this.localPosition);
}

class DrawableMaskFinishPathEvent extends DrawableMaskEvent {}

class DrawableMaskUndoEvent extends DrawableMaskEvent {}

class DrawableMaskRedoEvent extends DrawableMaskEvent {}

class DrawableMaskClearEvent extends DrawableMaskEvent {}

class DrawableMaskBrushSizeChangedEvent extends DrawableMaskEvent {
  final double brushSize;

  const DrawableMaskBrushSizeChangedEvent(this.brushSize);
}

class DrawableMaskVisibilityToggledEvent extends DrawableMaskEvent {
  const DrawableMaskVisibilityToggledEvent();
}
