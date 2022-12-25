part of 'drawable_mask_bloc.dart';

abstract class DrawableMaskState extends Equatable {
  const DrawableMaskState();

  @override
  List<Object?> get props => [];
}

class StateMaskInitial extends DrawableMaskState {
  @override
  List<Object?> get props => [];
}

class StateMaskLoaded extends DrawableMaskState {
  final AiArtRepo repo;

  const StateMaskLoaded(this.repo);

  @override
  List<Object?> get props => [repo];
}

class StateMaskProcessing extends DrawableMaskState {
  const StateMaskProcessing();

  @override
  List<Object?> get props => [];
}

class StateMaskError extends DrawableMaskState {
  final String message;

  const StateMaskError(this.message);

  @override
  List<Object?> get props => [message];
}

class StateMaskUndo extends DrawableMaskState {
  const StateMaskUndo();

  @override
  List<Object?> get props => [];
}

class StateMaskRedo extends DrawableMaskState {
  const StateMaskRedo();

  @override
  List<Object?> get props => [];
}
