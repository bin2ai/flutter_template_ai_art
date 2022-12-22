import 'package:flutter_template_ai_art/bloc/firebase_auth/firebase_auth_bloc.dart';
import 'package:flutter_template_ai_art/data/repos/firebase_auth_repo.dart';
import 'package:flutter_template_ai_art/screens/dashboard.dart';
import 'package:flutter_template_ai_art/screens/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'firebase_options.dart';
import 'screens/Home.dart';
import 'screens/art_image.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => FirebaseAuthRepo(),
      child: BlocProvider(
        create: (context) => AuthBloc(
          authRepository: RepositoryProvider.of<FirebaseAuthRepo>(context),
        ),
        child: MaterialApp(
          initialRoute: '/',
          routes: {
            '/': (context) => BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is UnAuthenticated) {
                      return const SignIn();
                    } else if (state is Authenticated) {
                      return const Dashboard();
                    } else {
                      return const SignIn();
                    }
                  },
                ),
            '/image': (context) => BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is UnAuthenticated) {
                      return const SignIn();
                    } else if (state is Authenticated) {
                      return const ImageEditPage();
                    } else {
                      return const SignIn();
                    }
                  },
                ),
          },
        ),
      ),
    );
  }
}
