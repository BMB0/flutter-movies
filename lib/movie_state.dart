import 'package:dio/dio.dart';
import 'package:movies/moviesAPI.dart';

class MovieState {
  MovieState();
}

class MovieInit extends MovieState {
  var movies = MoviesApi();
  final dio = Dio();

  MovieState() {
    getHttp();
  }

  Future<MoviesApi> getHttp() async {
    const url =
        'https://api.themoviedb.org/3/discover/movie?sort_by=popularity.desc&api_key=fa3e844ce31744388e07fa47c7c5d8c3';
    final response = await dio.get(url);

    if (response.data is Map<String, dynamic>) {
      movies = MoviesApi.fromJson(response.data);
      print("Numero de peliculas: ${movies.results!.length}");
      return movies;
    } else {
      throw Exception('Failed to load movies');
    }
  }
}

class MovieAdd extends MovieInit {
  MovieAdd();

  // void increment() {
  //   movies.results!.forEach((element) {
  //     element.amount = 0;
  //   });
  // }
}

class MovieSubtract extends MovieInit {
  MovieSubtract();
}

class MovieConfirm extends MovieInit {
  MovieConfirm();
}
