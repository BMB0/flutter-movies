import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/login_page.dart';
import 'package:movies/movie_cubit.dart';
import 'package:movies/movies_page.dart';
import 'package:movies/theme_cubit.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ThemeCubit(),
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CartCubit(),
      child: BlocBuilder<ThemeCubit, ThemeData>(
        builder: (_, theme) {
          return MaterialApp(
            theme: theme,
            home: LoginView(),
            routes: {
              '/login': (context) => LoginView(),
              '/movies': (context) => const MoviesView(),
              '/shoppingCart': (context) => const CartView(),
            },
          );
        },
      ),
    );
  }
}
