import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/movie_cubit.dart';
import 'package:movies/movie_state.dart';
import 'package:movies/movies_api.dart';
import 'package:movies/theme_cubit.dart';

class MoviesView extends StatelessWidget {
  const MoviesView({Key? key}) : super(key: key);

  Future<List<Results>> _getMoviesData() async {
    final dio = Dio();
    const url =
        'https://api.themoviedb.org/3/discover/movie?sort_by=popularity.desc&api_key=fa3e844ce31744388e07fa47c7c5d8c3';

    try {
      final response = await dio.get(url);

      if (response.data is Map<String, dynamic>) {
        final moviesApi = MoviesApi.fromJson(response.data);
        return moviesApi.results ?? [];
      } else {
        throw Exception('Failed to load movies');
      }
    } catch (e) {
      throw Exception('Failed to load movies: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Movies')),
      body: FutureBuilder<List<Results>>(
        future: _getMoviesData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No movies found"));
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(15),
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final movie = snapshot.data![index];
                return _buildMovieCard(context, movie);
              },
            );
          }
        },
      ),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  Widget _buildMovieCard(BuildContext context, Results movie) {
    return BlocBuilder<CartCubit, MovieState>(builder: (context, state) {
      return Column(
        children: [
          Container(
            margin: const EdgeInsets.all(5),
            width: 200,
            height: 300,
            child: Stack(
              children: [
                Image.network(
                  'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                  fit: BoxFit.fill,
                ),
                Positioned(
                  top: 0,
                  child: Container(
                    color: Colors.black54,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        movie.originalTitle ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 250,
                  left: 10,
                  child: Container(
                    color: const Color.fromARGB(174, 0, 0, 0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        context.read<CartCubit>().getAmount(movie).toString(),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 250,
                  right: 10,
                  child: Material(
                    shape: const CircleBorder(
                      side: BorderSide(
                        color: Colors.purple,
                        width: 2,
                      ),
                    ),
                    color: const Color.fromARGB(237, 255, 255, 255),
                    child: IconButton(
                      icon: const Icon(
                        Icons.add,
                        color: Colors.purple,
                        size: 30,
                      ),
                      onPressed: () {
                        context.read<CartCubit>().addToCart(movie);
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 250,
                  right: 70,
                  child: Material(
                    shape: const CircleBorder(
                      side: BorderSide(
                        color: Colors.purple,
                        width: 2,
                      ),
                    ),
                    color: const Color.fromARGB(232, 255, 255, 255),
                    child: IconButton(
                      icon: const Icon(
                        Icons.remove,
                        color: Colors.purple,
                        size: 30,
                      ),
                      onPressed: () {
                        context.read<CartCubit>().removeFromCart(movie);
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
          Row(
            children: [
              const Icon(
                Icons.star,
                color: Colors.yellow,
                size: 20,
              ),
              Text(
                '${movie.voteAverage}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
        ],
      );
    });
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FloatingActionButton(
                child: const Icon(Icons.brightness_6),
                onPressed: () {
                  context.read<ThemeCubit>().toggleTheme();
                },
              ),
            ],
          ),
        ),
        Expanded(
          flex: 0,
          child: BlocBuilder<CartCubit, MovieState>(
            builder: (context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  FloatingActionButton.extended(
                    onPressed: () {
                      Navigator.pushNamed(context, '/shoppingCart');
                    },
                    label: Text('Bs. ${state.amount.toStringAsFixed(0)}'),
                    icon: const Icon(Icons.shopping_cart),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class CartView extends StatelessWidget {
  const CartView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrito'),
      ),
      body: BlocBuilder<CartCubit, MovieState>(
        builder: (context, state) {
          final cart = state.movies;
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: cart.length,
                  itemBuilder: (context, index) {
                    final movie = cart[index];
                    return Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(5),
                          width: 200,
                          height: 300,
                          child: Stack(
                            children: [
                              Image.network(
                                'https://image.tmdb.org/t/p/w500${movie.$1.posterPath}',
                                fit: BoxFit.fill,
                              ),
                              Positioned(
                                top: 0,
                                child: Container(
                                  color: Colors.black54,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      movie.$1.originalTitle ?? '',
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 250,
                                left: 10,
                                child: Container(
                                  color: const Color.fromARGB(174, 0, 0, 0),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      context
                                          .read<CartCubit>()
                                          .getAmount(movie.$1)
                                          .toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 250,
                                right: 70,
                                child: Material(
                                  shape: const CircleBorder(
                                    side: BorderSide(
                                      color: Colors.purple,
                                      width: 2,
                                    ),
                                  ),
                                  color:
                                      const Color.fromARGB(232, 255, 255, 255),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.remove,
                                      color: Colors.purple,
                                      size: 30,
                                    ),
                                    onPressed: () {
                                      context
                                          .read<CartCubit>()
                                          .removeFromCart(movie.$1);
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Text(
                          'Bs. ${movie.$2 * 30}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.all(8.0),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.purple),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Resumen de la factura:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ...cart.map((movie) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '${movie.$1.originalTitle}: ${movie.$2} x Bs. 30 = Bs. ${movie.$2 * 30}',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Total: Bs. ${state.amount}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
