import 'package:movies/movies_api.dart';

class MovieState {
  final List<(Results, int)> movies;
  final int amount;

  MovieState(this.movies, this.amount);
}
