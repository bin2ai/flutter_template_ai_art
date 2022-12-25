import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/image_edit/image_bloc.dart';
import 'widgets/image_selector.dart';

class ImageEditScreen extends StatelessWidget {
  const ImageEditScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //material app
    return MaterialApp(
      title: 'Image Edit',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => ImageSelectBloc(),
        child: const Scaffold(
          body: ImageEditor(),
        ),
      ),
    );
  }
}
