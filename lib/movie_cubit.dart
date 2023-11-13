import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/movie_state.dart';
import 'package:movies/moviesApi.dart';

class CartCubit extends Cubit<MovieState> {
  CartCubit() : super(MovieState([], 0));
  static const price = 30;

  void addToCart(Results movie) {
    final List<(Results, int)> currentCart = state.movies;
    final int amount = state.amount;

    int index = currentCart.indexWhere((tuple) => tuple.$1.id == movie.id);
    if (index != -1) {
      // Si la película ya está en el carrito, incrementa su cantidad
      currentCart[index] = (currentCart[index].$1, currentCart[index].$2 + 1);
    } else {
      // Si la película no está en el carrito, la agrega
      currentCart.add((movie, 1));
    }

    final int newTotalCost = amount + price;

    emit(MovieState([...currentCart], newTotalCost));
  }

  void removeFromCart(Results movie) {
    final List<(Results, int)> currentCart = state.movies;
    final int amount = state.amount;

    int index = currentCart.indexWhere((tuple) => tuple.$1.id == movie.id);
    if (index != -1) {
      if (currentCart[index].$2 == 1) {
        currentCart.removeAt(index);
      } else {
        currentCart[index] = (currentCart[index].$1, currentCart[index].$2 - 1);
      }

      final int newTotalCost = amount - price;
      emit(MovieState([...currentCart], newTotalCost));
    }
  }

  int getAmount(Results movie) {
    final List<(Results, int)> currentCart = state.movies;
    int index = currentCart.indexWhere((tuple) => tuple.$1.id == movie.id);
    if (index == -1) {
      return 0;
    } else {
      return currentCart[index].$2;
    }
  }
}
