import 'package:movies/moviesApi.dart';

class MovieState {
  final List<Results> movies;
  final int amount;

  MovieState(this.movies, this.amount);
}
