import 'package:flutter/material.dart';

class SoloResultatScreen extends StatelessWidget {
  final String nomPokemon;
  final String type;
  final String region;
  final String couleur;
  final String taille;
  final double poids;
  final String stadeEvolution;
  final String forme;
  final bool isLegendary;
  final String description;
  final String sprite;
  final bool gagne;

  const SoloResultatScreen({
    required this.nomPokemon,
    required this.type,
    required this.region,
    required this.couleur,
    required this.taille,
    required this.poids,
    required this.stadeEvolution,
    required this.forme,
    required this.isLegendary,
    required this.description,
    required this.sprite,
    required this.gagne,
  });

  @override
  Widget build(BuildContext context) {
    final message = gagne
        ? '🎉 Bravo ! C’était $nomPokemon 🎉'
        : '😢 Dommage ! C’était $nomPokemon 😢';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0075BE),
        title: Text(
          'Résultat - Pokémon Fan Guess Game',
          style: TextStyle(color: Color(0xFFFFCC00)),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),

              Text(
                message,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 20),

              sprite.startsWith('http')
                  ? Image.network(sprite, width: 200, height: 200)
                  : Image.asset(sprite, width: 200, height: 200),

              SizedBox(height: 20),

              _infoText('Type', type),
              _infoText('Région', region),
              _infoText('Couleur', couleur),
              _infoText('Taille', taille),
              _infoText('Poids', '${poids.toStringAsFixed(1)} kg'),
              _infoText('Stade d\'évolution', stadeEvolution),
              _infoText('Forme', forme),
              _infoText('Légendaire', isLegendary ? 'Oui' : 'Non'),

              SizedBox(height: 10),

              Text(
                'Description :',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                description,
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 40),

              ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: Text('REVENIR À L’ACCUEIL'),
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

  Widget _infoText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        '$label : $value',
        style: TextStyle(fontSize: 18),
        textAlign: TextAlign.center,
      ),
    );
  }
}

/// Modèle représentant un Pokémon pour le jeu.
///
/// Exemple d'utilisation :
/// ```dart
/// final pikachu = Pokemon(
///   name: 'Pikachu',
///   types: ['Électrik'],
///   region: 'Kanto',
///   color: 'Jaune',
///   size: 'Petite',
///   weight: 6.0,
///   stadeEvolution: 'Stade 1',
///   forme: 'Quadrupède',
///   isLegendary: false,
///   description: 'Un Pokémon souris très populaire.',
///   sprite: 'assets/images/pikachu.png',
/// );
/// ```
class Pokemon {
  final String name;
  final List<String> types;
  final String region;
  final String color;
  final String size;
  final double weight;
  final String stadeEvolution;
  final String forme;
  final bool isLegendary;
  final String description;
  final String sprite;

  Pokemon({
    required this.name,
    required this.types,
    required this.region,
    required this.color,
    required this.size,
    required this.weight,
    required this.stadeEvolution,
    required this.forme,
    required this.isLegendary,
    required this.description,
    required this.sprite,
  });
}
