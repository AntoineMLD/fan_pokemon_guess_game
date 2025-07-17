import 'package:flutter/material.dart';
import '../models/pokemon.dart';
import '../utils/string_utils.dart';
import 'duo_pokemon_selection_screen.dart';
import 'duo_recap_screen.dart';

class DuoGuessScreen extends StatefulWidget {
  final String player1;
  final String player2;
  final int score1;
  final int score2;
  final bool isPlayer1Choosing;
  final Pokemon pokemonToGuess;

  const DuoGuessScreen({
    required this.player1,
    required this.player2,
    required this.score1,
    required this.score2,
    required this.isPlayer1Choosing,
    required this.pokemonToGuess,
    Key? key,
  }) : super(key: key);

  @override
  State<DuoGuessScreen> createState() => _DuoGuessScreenState();
}

class _DuoGuessScreenState extends State<DuoGuessScreen> {
  final TextEditingController _controller = TextEditingController();
  final Map<String, String> _revealed = {};
  int _attempts = 0;
  final int _maxAttempts = 5;
  String? _errorMessage;
  bool _finished = false;
  bool _found = false;

  void _reveal(String key, String value) {
    setState(() {
      _revealed[key] = value;
    });
  }

  void _validateProposition() {
    final input = normalize(_controller.text);
    if (input.isEmpty) return;
    final answer = normalize(widget.pokemonToGuess.name);
    if (input == answer) {
      setState(() {
        _finished = true;
        _found = true;
      });
    } else {
      setState(() {
        _attempts += 1;
        if (_attempts >= _maxAttempts) {
          _finished = true;
          _found = false;
        } else {
          _errorMessage = "❌ Mauvaise réponse ! Essaie encore.";
        }
      });
    }
    _controller.clear();
  }

  void _stopGame() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => DuoRecapScreen(
          player1: widget.player1,
          player2: widget.player2,
          score1: _updatedScore1(),
          score2: _updatedScore2(),
        ),
      ),
    );
  }

  void _nextRound() {
    // Calcul du score
    int score1 = widget.score1;
    int score2 = widget.score2;
    if (widget.isPlayer1Choosing) {
      // Joueur 2 devinait
      if (_found) {
        score2 += 10;
      } else {
        score2 -= 2 * _maxAttempts;
      }
    } else {
      // Joueur 1 devinait
      if (_found) {
        score1 += 10;
      } else {
        score1 -= 2 * _maxAttempts;
      }
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => DuoPokemonSelectionScreen(
          player1: widget.player1,
          player2: widget.player2,
          score1: score1,
          score2: score2,
          isPlayer1Choosing: !widget.isPlayer1Choosing,
        ),
      ),
    );
  }

  int _updatedScore1() {
    if (! _finished) return widget.score1;
    if (widget.isPlayer1Choosing) {
      // Joueur 2 devinait
      return widget.score1;
    } else {
      // Joueur 1 devinait
      return widget.score1 + (_found ? 10 : -2 * _maxAttempts);
    }
  }

  int _updatedScore2() {
    if (! _finished) return widget.score2;
    if (widget.isPlayer1Choosing) {
      // Joueur 2 devinait
      return widget.score2 + (_found ? 10 : -2 * _maxAttempts);
    } else {
      // Joueur 1 devinait
      return widget.score2;
    }
  }

  @override
  Widget build(BuildContext context) {
    final guesser = widget.isPlayer1Choosing ? widget.player2 : widget.player1;
    final chooser = widget.isPlayer1Choosing ? widget.player1 : widget.player2;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0075BE),
        title: Text('À toi de deviner !', style: TextStyle(color: Color(0xFFFFCC00))),
        actions: [
          IconButton(
            icon: Icon(Icons.stop),
            tooltip: 'Arrêter la partie',
            onPressed: _stopGame,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _scoreBox(widget.player1, widget.score1),
                _scoreBox(widget.player2, widget.score2),
              ],
            ),
            SizedBox(height: 20),
            Text('$guesser, devine le Pokémon choisi par $chooser',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            SizedBox(height: 20),
            if (!_finished) ...[
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: [
                  ElevatedButton(onPressed: () => _reveal('Couleur', widget.pokemonToGuess.color), child: Text('Couleur ?'), style: _buttonStyle()),
                  ElevatedButton(onPressed: () => _reveal('Type', widget.pokemonToGuess.types.join(' / ')), child: Text('Type ?'), style: _buttonStyle()),
                  ElevatedButton(onPressed: () => _reveal('Région', widget.pokemonToGuess.region), child: Text('Région ?'), style: _buttonStyle()),
                  ElevatedButton(onPressed: () => _reveal('Taille', widget.pokemonToGuess.size), child: Text('Taille ?'), style: _buttonStyle()),
                  ElevatedButton(onPressed: () => _reveal('Poids', '${widget.pokemonToGuess.weight.toStringAsFixed(1)} kg'), child: Text('Poids ?'), style: _buttonStyle()),
                  ElevatedButton(onPressed: () => _reveal('Description', widget.pokemonToGuess.description), child: Text('Description ?'), style: _buttonStyle()),
                  ElevatedButton(onPressed: () => _reveal('Stade Evolution', widget.pokemonToGuess.stadeEvolution), child: Text('Stade d\'évolution ?'), style: _buttonStyle()),
                  ElevatedButton(onPressed: () => _reveal('Forme', widget.pokemonToGuess.forme), child: Text('Forme ?'), style: _buttonStyle()),
                  ElevatedButton(onPressed: () => _reveal('Légendaire', widget.pokemonToGuess.isLegendary ? 'Oui' : 'Non'), child: Text('Légendaire ?'), style: _buttonStyle()),
                ],
              ),
              SizedBox(height: 20),
              if (_revealed.isNotEmpty) ...[
                Text('Indices révélés :', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                ..._revealed.entries.map((e) => Text('🔹 ${e.key} : ${e.value}')),
                SizedBox(height: 20),
              ],
              if (_errorMessage != null) ...[
                Text(_errorMessage!, style: TextStyle(color: Colors.red, fontSize: 16), textAlign: TextAlign.center),
                SizedBox(height: 10),
              ],
              Text('Essais : $_attempts / $_maxAttempts', style: TextStyle(fontSize: 18, color: Colors.grey[700])),
              SizedBox(height: 20),
              Text('Entrez votre proposition :', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Nom du Pokémon',
                ),
                onSubmitted: (_) => _validateProposition(),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: (_attempts < _maxAttempts) ? _validateProposition : null,
                child: Text('VALIDER'),
                style: _buttonStyle(),
              ),
            ],
            if (_finished) ...[
              SizedBox(height: 30),
              Center(
                child: Column(
                  children: [
                    Builder(
                      builder: (context) {
                        final screenWidth = MediaQuery.of(context).size.width;
                        final spriteSize = screenWidth * 0.6;
                        final clampedSize = spriteSize.clamp(120.0, 300.0);
                        return widget.pokemonToGuess.sprite.isNotEmpty
                            ? Image.network(widget.pokemonToGuess.sprite, width: clampedSize, height: clampedSize)
                            : SizedBox.shrink();
                      },
                    ),
                    SizedBox(height: 20),
                    Text(_found ? '🎉 Bravo ! C’était ${widget.pokemonToGuess.name} 🎉' : '😢 Dommage ! C’était ${widget.pokemonToGuess.name} 😢',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _nextRound,
                      child: Text('Manche suivante'),
                      style: _buttonStyle(),
                    ),
                  ],
                ),
              ),
            ],
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

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Color(0xFF0075BE),
      foregroundColor: Color(0xFFFFCC00),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      textStyle: TextStyle(fontSize: 16),
    );
  }
} 