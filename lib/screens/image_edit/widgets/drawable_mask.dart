import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/mask_edit/drawable_mask_bloc.dart';

class DrawableMask extends StatelessWidget {
  const DrawableMask({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DrawableMaskBloc, DrawableMaskState>(
      builder: (context, state) {
        return Stack(
          fit: StackFit.passthrough,
          children: [
            //gesture detector on top of mask to allow user to edit mask
            GestureDetector(
              onPanUpdate: (details) {
                //call DrawableMaskContinuePathEvent
                context
                    .read<DrawableMaskBloc>()
                    .add(DrawableMaskContinuePathEvent(Offset(
                      details.globalPosition.dx,
                      details.globalPosition.dy,
                    )));
              },
              onPanEnd: (details) {
                context
                    .read<DrawableMaskBloc>()
                    .add(DrawableMaskFinishPathEvent());
              },
              child: SizedBox(
                child: state is StateMaskLoaded && state.repo.isMaskVisible
                    ? CustomPaint(
                        painter: state.repo.painter,
                        willChange: true,
                        child: Container(),
                      )
                    : Container(),
              ),
            ),
            //4 buttons, show/hidden (eye icon), undo, redo, delete, all of which are disabled if mask is not visible, bottom left
            Positioned(
              bottom: 0,
              left: 0,
              child: SizedBox(
                height: 100,
                child: Row(
                  children: [
                    IconButton(
                      color: Colors.red,
                      icon: Icon(
                        state is StateMaskInitial
                            ? Icons.visibility_off
                            : state is StateMaskLoaded
                                ? state.repo.isMaskVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off
                                : Icons.visibility_off,
                      ),
                      onPressed: () {
                        //call bloc event
                        BlocProvider.of<DrawableMaskBloc>(context)
                            .add(const DrawableMaskVisibilityToggledEvent());
                      },
                    ),
                    state is StateMaskLoaded && state.repo.isMaskVisible
                        ? Row(
                            children: [
                              //undo
                              IconButton(
                                icon: const Icon(Icons.undo),
                                onPressed: () {
                                  BlocProvider.of<DrawableMaskBloc>(context)
                                      .add(DrawableMaskUndoEvent());
                                },
                              ),
                              //redo
                              IconButton(
                                  icon: const Icon(Icons.redo),
                                  onPressed: () {
                                    BlocProvider.of<DrawableMaskBloc>(context)
                                        .add(DrawableMaskRedoEvent());
                                  }),
                              //delete
                              IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    BlocProvider.of<DrawableMaskBloc>(context)
                                        .add(DrawableMaskClearEvent());
                                  }),
                            ],
                          )
                        : const SizedBox(), //if no mask, show nothing
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
