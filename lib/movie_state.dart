import 'package:dio/dio.dart';
import 'package:movies/moviesAPI.dart';

class MovieState {
  final dio = Dio();
  var movie;

  Future<MoviesApi> getHttp() async {
    const url =
        'https://api.themoviedb.org/3/discover/movie?sort_by=popularity.desc&api_key=fa3e844ce31744388e07fa47c7c5d8c3';
    final response = await dio.get(url);
    final moviesApi = moviesApiFromJson(response.toString());
    return moviesApi;
  }

  MovieState() {
    getHttp().then((value) => movie = value);
  }
}

class MovieInit extends MovieState {
  MovieInit();
}

class MovieAdd extends MovieState {
  MovieAdd();
}

class MovieSubtract extends MovieState {
  MovieSubtract();
}

class MovieConfirm extends MovieState {
  MovieConfirm();
}
