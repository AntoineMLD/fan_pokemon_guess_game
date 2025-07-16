import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pokemon_provider.dart';
import 'solo_proposition_screen.dart';

class AccueilScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0075BE),
        title: Text(
          'Accueil - Pokémon Fan Guess Game',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Image.asset(
                'assets/images/pokemon_logo.jpeg',
                width: 200,
                height: 200,
              ),
              SizedBox(height: 30),
              Text(
                'Quel est ce Pokémon ?',
                style: TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  await Provider.of<PokemonProvider>(context, listen: false).loadRandomPokemon();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => SoloPropositionScreen()),
                  );
                },
                child: Text('SOLO'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF0075BE),
                  foregroundColor: Color(0xFFFFCC00),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
