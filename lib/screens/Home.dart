import 'package:flutter_template_ai_art/bloc/text_to_image/bloc/text_to_image_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String prompt = "Type a prompt here";
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<TextToImageBloc, TextToImageState>(
            listener: (context, state) {},
          ),
        ],
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //get state from context
              BlocBuilder<TextToImageBloc, TextToImageState>(
                builder: (context, state) {
                  return stateImageDisplay(context, state);
                },
              ),
              TextFormField(
                initialValue: prompt,
                onChanged: (value) {
                  prompt = value;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                child: const Text('Begin Text to Image'),
                onPressed: () {
                  print("Button pressed");
                  print(prompt);
                  // Signing out the user
                  context
                      .read<TextToImageBloc>()
                      .add(TextToImageGenerate(prompt: prompt));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget stateImageDisplay(context, state) {
  if (state is TextToImageInitial) {
    // random image widget
    return Image.network("https://picsum.photos/300/300");
  } else if (state is TextToImageLoading) {
    // loading circle widget
    return const CircularProgressIndicator();
  } else if (state is TextToImageLoaded) {
    // display all images from state prop images
    return displayAllImages(state.images);
  } else if (state is TextToImageError) {
    // display error message
    return Text(state.message);
  }
  return Image.network("https://picsum.photos/300/300");
}

Widget displayAllImages(List<Image> images) {
  return SizedBox(
    height: 300,
    child: ListView.builder(
      itemCount: images.length,
      itemBuilder: (context, index) {
        return images[index];
      },
    ),
  );
}
