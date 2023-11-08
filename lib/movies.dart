import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/movie_cubit.dart';
import 'package:movies/movie_state.dart';
import 'package:movies/moviesAPI.dart';

class Movies extends StatefulWidget {
  const Movies({Key? key}) : super(key: key);

  @override
  State<Movies> createState() => _MoviesState();
}

class _MoviesState extends State<Movies> {
  final dio = Dio();
  static const Precio = 30;

  Future<List<Result>> getHttp() async {
    const url =
        'https://api.themoviedb.org/3/discover/movie?sort_by=popularity.desc&api_key=fa3e844ce31744388e07fa47c7c5d8c3';
    final response = await dio.get(url);
    final moviesApi = moviesApiFromJson(response.toString());
    return moviesApi.results;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Movies"),
        ),
        body: BlocBuilder<MovieCubit, int>(builder: (context, count) {
          return FutureBuilder<List<Result>>(
            future: getHttp(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var movie = snapshot.data![index];
                    return Row(
                      children: [
                        Expanded(
                          child: Text(movie.title,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text('$count'),
                              ElevatedButton(
                                  onPressed: () =>
                                      context.read<MovieCubit>().increment(),
                                  child: const Text("Agregar")),
                              ElevatedButton(
                                  onPressed: () =>
                                      context.read<MovieCubit>().decrement(),
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
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return const CircularProgressIndicator();
            },
          );
        }),
      ),
    );
  }
}
