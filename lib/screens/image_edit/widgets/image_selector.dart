import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/image_edit/image_bloc.dart';
import '../../../bloc/mask_edit/drawable_mask_bloc.dart';
import '../../widgets/drawable_mask.dart';

class ImageEditor extends StatelessWidget {
  const ImageEditor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("here");
    //bloc builder
    return Scaffold(
      appBar: AppBar(title: const Text('Image Editor')),
      body: BlocBuilder<ImageSelectBloc, ImageSelectState>(
        builder: (context, state) {
          return Container(
            width: 512,
            height: 512,
            //dark mode
            color: Colors.grey[850],
            child: Stack(
              children: [
                //image
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    alignment: Alignment.center,
                    width: 512,
                    height: 512,
                    color: Colors.grey[850],
                    child:
                        // BoxDecoration(image: DecorationImage(image:
                        state is StateSelectImageInitial
                            ? const Center(child: Text('No Image'))
                            : state is StateSelectImageLoaded
                                ? Image.memory(state.image,
                                    fit: BoxFit.fitWidth)
                                : state is StateSelectImageLoading
                                    ? const CircularProgressIndicator()
                                    : const Center(child: Text('No Image')),
                  ),
                ),
                state is StateSelectImageLoaded
                    ?
                    //drawablemask
                    Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                          width: 512,
                          height: 512,
                          color: Colors.transparent,
                          child: BlocProvider(
                            create: (context) => DrawableMaskBloc(),
                            child: const DrawableMask(),
                          ),
                        ),
                      )
                    : Container(),

                //buttons, positioned top left
                Positioned(
                  top: 0,
                  left: 0,
                  child: state is StateSelectImageInitial
                      ? InkWell(
                          child: const Icon(Icons.add_a_photo),
                          onTap: () {
                            BlocProvider.of<ImageSelectBloc>(context).add(
                              EventSelectImage(),
                            );
                          },
                        )
                      : state is StateSelectImageLoaded
                          ?
                          //remove image
                          InkWell(
                              child: const Icon(Icons.delete),
                              onTap: () {
                                BlocProvider.of<ImageSelectBloc>(context).add(
                                  EventRemoveImage(),
                                );
                              },
                            )
                          : Container(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
