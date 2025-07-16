import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/pokemon_provider.dart';
import 'screens/accueil_screen.dart';

void main() {
  runApp(PokeFanApp());
}

class PokeFanApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PokemonProvider(),
      child: MaterialApp(
        title: 'Pokémon Fan Guess Game',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: AccueilScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
