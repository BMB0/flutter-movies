import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/movie_cubit.dart';
import 'package:movies/movie_state.dart';
import 'package:movies/moviesApi.dart';
import 'package:movies/theme_cubit.dart';

class MoviesPage extends StatelessWidget {
  const MoviesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MoviesBloc(),
      child: MoviesView(),
    );
  }
}

class MoviesView extends StatelessWidget {
  const MoviesView({super.key});

  Future<MoviesApi> getHttp() async {
    final dio = Dio();
    const url =
        'https://api.themoviedb.org/3/discover/movie?sort_by=popularity.desc&api_key=fa3e844ce31744388e07fa47c7c5d8c3';
    final response = await dio.get(url);

    if (response.data is Map<String, dynamic>) {
      MoviesApi moviesApi = MoviesApi.fromJson(response.data);
      return moviesApi;
    } else {
      throw Exception('Failed to load movies');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Movies')),
      body: Center(
        child: BlocBuilder<MoviesBloc, int>(
          builder: (context, count) {
            return FutureBuilder<MoviesApi>(
                future: getHttp(),
                builder: (context, movies) {
                  if (movies.hasData) {
                    return ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: movies.data?.results!.length,
                      itemBuilder: (context, index) {
                        Results movie = movies.data!.results![index];
                        return Row(
                          children: [
                            Expanded(
                              child: Text(movie.originalTitle!,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(movie.amount.toString()),
                                  ElevatedButton(
                                      onPressed: () =>
                                          {movie.amount = movie.amount! + 1},
                                      child: const Text("Agregar")),
                                  ElevatedButton(
                                      onPressed: () =>
                                          {movie.amount = movie.amount! - 1},
                                      child: const Text("Decrementar")),
                                  ElevatedButton(
                                      onPressed: () => {},
                                      child: const Text("Confirmar")),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  } else if (movies.hasError) {
                    return Text("${movies.error}");
                  }
                  return const CircularProgressIndicator();
                });
            // return Text(
            //   '$count',
            //   style: Theme.of(context).textTheme.displayLarge,
            // );
          },
        ),
      ),
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          // const SizedBox(height: 4),
          FloatingActionButton(
            child: const Icon(Icons.brightness_6),
            onPressed: () {
              context.read<ThemeCubit>().toggleTheme();
            },
          ),
        ],
      ),
    );
  }
}

// class MoviesView extends StatelessWidget {
//   const MoviesView({super.key});
//   final dio = Dio();
//   var movies = MoviesApi();

//   Future<MoviesApi> getHttp() async {
//     const url =
//         'https://api.themoviedb.org/3/discover/movie?sort_by=popularity.desc&api_key=fa3e844ce31744388e07fa47c7c5d8c3';
//     final response = await dio.get(url);

//     if (response.data is Map<String, dynamic>) {
//       MoviesApi moviesApi = MoviesApi.fromJson(response.data);
//       print("Numero de peliculas: ${moviesApi.results!.length}");
//       return moviesApi;
//     } else {
//       throw Exception('Failed to load movies');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text("Movies"),
//         ),
//         body: BlocBuilder<MovieCubit, MovieState>(builder: (context, state) {
//           return FutureBuilder<MoviesApi>(
//             future: state,
//             builder: (context, movies) {
//               if (movies.hasData) {
//                 return ListView.builder(
//                   padding: const EdgeInsets.all(10),
//                   itemCount: movies.data?.results!.length,
//                   itemBuilder: (context, index) {
//                     Results movie = movies.data!.results![index];
//                     return Row(
//                       children: [
//                         Expanded(
//                           child: Text(movie.originalTitle!,
//                               style: const TextStyle(
//                                   color: Colors.black,
//                                   fontSize: 15,
//                                   fontWeight: FontWeight.bold)),
//                         ),
//                         Expanded(
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               Text(movie.amount.toString()),
//                               ElevatedButton(
//                                   onPressed: () =>
//                                       {movie.amount = movie.amount! + 1},
//                                   child: const Text("Agregar")),
//                               ElevatedButton(
//                                   onPressed: () =>
//                                       {movie.amount = movie.amount! - 1},
//                                   child: const Text("Decrementar")),
//                               ElevatedButton(
//                                   onPressed: () => {},
//                                   child: const Text("Confirmar")),
//                             ],
//                           ),
//                         ),
//                       ],
//                     );
//                   },
//                 );
//               } else if (movies.hasError) {
//                 return Text("${movies.error}");
//               }
//               return const CircularProgressIndicator();
//             },
//           );
//         }),
//       ),
//     );
//   }
// }
