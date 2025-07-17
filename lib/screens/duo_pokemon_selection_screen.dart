import 'package:flutter/material.dart';
import '../models/pokemon.dart';
import '../services/pokemon_service.dart';
import 'duo_guess_screen.dart';

class DuoPokemonSelectionScreen extends StatefulWidget {
  final String player1;
  final String player2;
  final int score1;
  final int score2;
  final bool isPlayer1Choosing;

  const DuoPokemonSelectionScreen({
    required this.player1,
    required this.player2,
    required this.score1,
    required this.score2,
    required this.isPlayer1Choosing,
    Key? key,
  }) : super(key: key);

  @override
  State<DuoPokemonSelectionScreen> createState() => _DuoPokemonSelectionScreenState();
}

class _DuoPokemonSelectionScreenState extends State<DuoPokemonSelectionScreen> {
  late Future<List<Pokemon>> _pokemonsFuture;

  @override
  void initState() {
    super.initState();
    _pokemonsFuture = _fetchRandomPokemons(50);
  }

  Future<List<Pokemon>> _fetchRandomPokemons(int count) async {
    final List<Future<Pokemon?>> futures = List.generate(count, (_) async {
      try {
        return await PokemonService.fetchRandomPokemon();
      } catch (_) {
        return null;
      }
    });
    final results = await Future.wait(futures);
    // Si certains sont null (erreur), on relance pour compléter jusqu'à 50
    List<Pokemon> pokemons = results.whereType<Pokemon>().toList();
    while (pokemons.length < count) {
      try {
        final p = await PokemonService.fetchRandomPokemon();
        pokemons.add(p);
      } catch (_) {
        // ignore
      }
    }
    return pokemons;
  }

  void _choosePokemon(Pokemon chosen) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DuoGuessScreen(
          player1: widget.player1,
          player2: widget.player2,
          score1: widget.score1,
          score2: widget.score2,
          isPlayer1Choosing: widget.isPlayer1Choosing,
          pokemonToGuess: chosen,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chooser = widget.isPlayer1Choosing ? widget.player1 : widget.player2;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final crossAxisCount = isMobile ? 3 : 5;
    final spriteSize = isMobile ? 90.0 : 60.0;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0075BE),
        title: Text('Sélection du Pokémon', style: TextStyle(color: Color(0xFFFFCC00))),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('$chooser, choisis un Pokémon à faire deviner',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _scoreBox(widget.player1, widget.score1),
                _scoreBox(widget.player2, widget.score2),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<List<Pokemon>>(
                future: _pokemonsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Erreur lors du chargement des Pokémon'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('Aucun Pokémon trouvé'));
                  }
                  final pokemons = snapshot.data!;
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: pokemons.length,
                    itemBuilder: (context, index) {
                      final p = pokemons[index];
                      return GestureDetector(
                        onTap: () => _choosePokemon(p),
                        child: Card(
                          elevation: 2,
                          color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              p.sprite.isNotEmpty
                                  ? Image.network(p.sprite, width: spriteSize, height: spriteSize, fit: BoxFit.contain)
                                  : SizedBox(width: spriteSize, height: spriteSize),
                              SizedBox(height: 8),
                              Text(p.name, textAlign: TextAlign.center, style: TextStyle(fontSize: 14)),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _scoreBox(String name, int score) {
    return Column(
      children: [
        Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
        Container(
          margin: EdgeInsets.only(top: 4),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Color(0xFFFFCC00),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text('$score pts', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
} 