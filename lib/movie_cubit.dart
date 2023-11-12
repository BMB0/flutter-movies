import 'package:flutter_bloc/flutter_bloc.dart';

/// Event being processed by [MoviesBloc].
abstract class MovieEvent {}

/// Notifies bloc to increment state.
class MovieIncrementPressed extends MovieEvent {}

/// Notifies bloc to decrement state.
class MovieDecrementPressed extends MovieEvent {}

class MoviesBloc extends Cubit<int> {
  MoviesBloc() : super(0) {}
}
