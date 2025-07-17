import 'package:flutter/material.dart';
import 'duo_pokemon_selection_screen.dart';

class DuoPlayerNamesScreen extends StatefulWidget {
  @override
  _DuoPlayerNamesScreenState createState() => _DuoPlayerNamesScreenState();
}

class _DuoPlayerNamesScreenState extends State<DuoPlayerNamesScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _player1Controller = TextEditingController();
  final TextEditingController _player2Controller = TextEditingController();

  void _startDuoGame() {
    if (_formKey.currentState!.validate()) {
      final player1 = _player1Controller.text.trim();
      final player2 = _player2Controller.text.trim();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DuoPokemonSelectionScreen(
            player1: player1,
            player2: player2,
            score1: 0,
            score2: 0,
            isPlayer1Choosing: true,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0075BE),
        title: Text('Mode Duo - Joueurs', style: TextStyle(color: Color(0xFFFFCC00))),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Entrez le nom des deux joueurs', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 30),
                TextFormField(
                  controller: _player1Controller,
                  decoration: InputDecoration(
                    labelText: 'Joueur 1',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.trim().isEmpty ? 'Nom du joueur 1 requis' : null,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _player2Controller,
                  decoration: InputDecoration(
                    labelText: 'Joueur 2',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.trim().isEmpty ? 'Nom du joueur 2 requis' : null,
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _startDuoGame,
                  child: Text('COMMENCER'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0075BE),
                    foregroundColor: Color(0xFFFFCC00),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 