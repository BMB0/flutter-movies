import 'package:bloc/bloc.dart';
// import 'package:movies/movie_state.dart';

class MovieCubit extends Cubit<int> {
  MovieCubit() : super(0);

  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);
}
