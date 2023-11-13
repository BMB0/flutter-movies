import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/movie_state.dart';
import 'package:movies/moviesApi.dart';

class CartCubit extends Cubit<MovieState> {
  CartCubit() : super(MovieState([], 0));
  static const price = 30;

  void addToCart(Results movie) {
    final List<Results> currentCart = state.movies;
    final int amount = state.amount;
    currentCart.add(movie);

    final int newTotalCost = amount + price;

    emit(MovieState([...currentCart], newTotalCost));
  }

  void removeFromCart(Results movie) {
    final List<Results> currentCart = state.movies;
    final int amount = state.amount;

    if (currentCart.contains(movie)) {
      currentCart.remove(movie);
      final int newTotalCost = amount - price;
      emit(MovieState([...currentCart], newTotalCost));
    }
  }
}
