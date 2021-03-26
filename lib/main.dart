import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app/cubit/authentication/authentication_cubit.dart';
import 'app/cubit/todos/todos_cubit.dart';
import 'app/pages/sign_in/sign_in_page.dart';
import 'app/pages/todos/todos_page.dart';
import 'data/repositories/authentication/firebase_auth_repository.dart';
import 'data/repositories/todos/firebase_todos_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(brightness: Brightness.dark),
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationCubit>(
            create: (context) => AuthenticationCubit(
              repo: FirebaseAuthRepository(),
            )..authChanges(),
          ),
          BlocProvider<TodosCubit>(
            create: (context) => TodosCubit(
              repo: FirebaseTodosRepository(),
            ),
          ),
        ],
        child: BlocBuilder<AuthenticationCubit, AuthenticationState>(
          builder: (context, state) {
            if (state is Authenticated) {
              return TodosPage();
            }
            //if state is unauthenticated or error show sign in page
            return SignInPage();
          },
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
