import 'package:flutter/material.dart';
import '../models/pokemon.dart';
import '../services/pokemon_service.dart';

class PokemonProvider with ChangeNotifier {
  Pokemon? _currentPokemon;

  Pokemon? get currentPokemon => _currentPokemon;

  Future<void> loadRandomPokemon() async {
    _currentPokemon = await PokemonService.fetchRandomPokemon();
    notifyListeners();
  }

  void clear() {
    _currentPokemon = null;
    notifyListeners();
  }
}
