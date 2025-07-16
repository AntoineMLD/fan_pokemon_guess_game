import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pokemon_provider.dart';
import 'solo_resultat_screen.dart';
import '../utils/string_utils.dart';

class SoloPropositionScreen extends StatefulWidget {
  @override
  _SoloPropositionScreenState createState() => _SoloPropositionScreenState();
}

class _SoloPropositionScreenState extends State<SoloPropositionScreen> {
  final TextEditingController _controller = TextEditingController();
  final Map<String, String> _revealed = {};
  int _attempts = 0;
  final int _maxAttempts = 5;
  String? _errorMessage;

  void _reveal(String key, String value) {
    setState(() {
      _revealed[key] = value;
    });
  }

  void _validateProposition() {
    final input = normalize(_controller.text);
    if (input.isEmpty) return;

    final pokemon = Provider.of<PokemonProvider>(context, listen: false).currentPokemon!;
    final answer = normalize(pokemon.name);

    if (input == answer) {
      Navigator.push(context, MaterialPageRoute(
        builder: (_) => SoloResultatScreen(
          nomPokemon: pokemon.name,
          type: pokemon.types.join('/'),
          region: pokemon.region,
          couleur: pokemon.color,
          taille: pokemon.size,
          poids: pokemon.weight,
          stadeEvolution: pokemon.stadeEvolution,
          forme: pokemon.forme,
          isLegendary: pokemon.isLegendary,
          description: pokemon.description,
          sprite: pokemon.sprite,
          gagne: true,
        ),
      ));
    } else {
      setState(() {
        _attempts += 1;
        _errorMessage = "❌ Mauvaise réponse ! Essaie encore.";
      });
    }

    _controller.clear();
  }

  void _showSolution() {
    final pokemon = Provider.of<PokemonProvider>(context, listen: false).currentPokemon!;
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => SoloResultatScreen(
        nomPokemon: pokemon.name,
        type: pokemon.types.join('/'),
        region: pokemon.region,
        couleur: pokemon.color,
        taille: pokemon.size,
        poids: pokemon.weight,
        stadeEvolution: pokemon.stadeEvolution,
        forme: pokemon.forme,
        isLegendary: pokemon.isLegendary,
        description: pokemon.description,
        sprite: pokemon.sprite,
        gagne: false,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final pokemon = Provider.of<PokemonProvider>(context).currentPokemon;

    if (pokemon == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Proposition'),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0075BE),
        title: Text(
          'Proposer un Pokémon',
          style: TextStyle(color: Color(0xFFFFCC00)),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            Image.asset(
              'assets/images/who_picture.jpeg',
              width: 200,
              height: 200,
            ),
            SizedBox(height: 20),

            Text(
              'Pose ta question :',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                ElevatedButton(onPressed: () => _reveal('Couleur', pokemon.color), child: Text('Couleur ?'), style: _buttonStyle()),
                ElevatedButton(onPressed: () => _reveal('Type', pokemon.types.join(' / ')), child: Text('Type ?'), style: _buttonStyle()),
                ElevatedButton(onPressed: () => _reveal('Région', pokemon.region), child: Text('Région ?'), style: _buttonStyle()),
                ElevatedButton(onPressed: () => _reveal('Taille', pokemon.size), child: Text('Taille ?'), style: _buttonStyle()),
                ElevatedButton(onPressed: () => _reveal('Poids', '${pokemon.weight.toStringAsFixed(1)} kg'), child: Text('Poids ?'), style: _buttonStyle()),
                ElevatedButton(onPressed: () => _reveal('Description', pokemon.description), child: Text('Description ?'), style: _buttonStyle()),
                ElevatedButton(onPressed: () => _reveal('Stade Evolution', pokemon.stadeEvolution), child: Text('Stade d\'évolution ?'), style: _buttonStyle()),
                ElevatedButton(onPressed: () => _reveal('Forme', pokemon.forme), child: Text('Forme ?'), style: _buttonStyle()),
                ElevatedButton(onPressed: () => _reveal('Légendaire', pokemon.isLegendary ? 'Oui' : 'Non'), child: Text('Légendaire ?'), style: _buttonStyle()),
              ],
            ),

            SizedBox(height: 20),

            if (_revealed.isNotEmpty) ...[
              Text(
                'Indices révélés :',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ..._revealed.entries.map((e) => Text('🔹 ${e.key} : ${e.value}')),
              SizedBox(height: 20),
            ],

            if (_errorMessage != null) ...[
              Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
            ],

            Text(
              'Essais : $_attempts / $_maxAttempts',
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
            ),

            SizedBox(height: 20),

            Text(
              'Entrez votre proposition :',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Nom du Pokémon',
              ),
            ),
            SizedBox(height: 20),

            ElevatedButton(
              onPressed: (_attempts < _maxAttempts) ? _validateProposition : null,
              child: Text('VALIDER'),
              style: _buttonStyle(),
            ),

            SizedBox(height: 20),

            if (_attempts >= _maxAttempts)
              ElevatedButton(
                onPressed: _showSolution,
                child: Text('VOIR LA SOLUTION'),
                style: _buttonStyle(),
              ),
          ],
        ),
      ),
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
