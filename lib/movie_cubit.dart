import 'package:bloc/bloc.dart';
import 'package:movies/movie_state.dart';

class MovieCubit extends Cubit<MovieState> {
  MovieCubit() : super(MovieInit());

  void addData() {}
}
