import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pokemon_provider.dart';
import 'solo_proposition_screen.dart';

class SoloScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0075BE),
        title: Text(
          'Mode Solo - Pokémon Fan Guess Game',
          style: TextStyle(color: Color(0xFFFFCC00)),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/who_picture.jpeg',
              width: 200,
              height: 200,
            ),
            SizedBox(height: 20),
            Text(
              'Bienvenue ! Devine le Pokémon en posant des questions.',
              style: TextStyle(fontSize: 24, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Provider.of<PokemonProvider>(context, listen: false)
                    .loadRandomPokemon()
                    .then((_) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => SoloPropositionScreen()),
                  );
                });
              },
              child: Text('Commencer le jeu'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF0075BE),
                foregroundColor: Color(0xFFFFCC00),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
