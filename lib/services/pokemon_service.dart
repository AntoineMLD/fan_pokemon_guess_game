import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';
import '../utils/string_utils.dart';

class PokemonService {
  static const _baseUrl = 'https://pokeapi.co/api/v2';

  static const Map<String, String> regionMap = {
    'generation-i': 'Kanto',
    'generation-ii': 'Johto',
    'generation-iii': 'Hoenn',
    'generation-iv': 'Sinnoh',
    'generation-v': 'Unys',
    'generation-vi': 'Kalos',
    'generation-vii': 'Alola',
    'generation-viii': 'Galar',
    'generation-ix': 'Paldea',
  };

  static const Map<String, String> colorMap = {
    'black': 'Noir',
    'blue': 'Bleu',
    'brown': 'Marron',
    'gray': 'Gris',
    'green': 'Vert',
    'pink': 'Rose',
    'purple': 'Violet',
    'red': 'Rouge',
    'white': 'Blanc',
    'yellow': 'Jaune',
  };

  static const Map<String, String> shapeMap = {
    'ball': 'Sphérique',
    'squiggle': 'Serpentin',
    'fish': 'Poisson',
    'upright': 'Vertical',
    'legs': 'Jambes',
    'quadruped': 'Quadrupède',
    'wings': 'Ailé',
    'tentacles': 'Tentaculaire',
    'head-legs': 'Tête et jambes',
    'head-arms': 'Tête et bras',
    'armor': 'Armuré',
    'blob': 'Masse informe',
    'bipedal_tailed': 'Bipède avec queue',
    'bipedal_tailless': 'Bipède sans queue',
    'serpentine_body': 'Serpentiforme',
    'head_base': 'Tête',
  };

  static const Map<String, String> typeMap = {
    'normal': 'Normal',
    'fire': 'Feu',
    'water': 'Eau',
    'electric': 'Électrik',
    'grass': 'Plante',
    'ice': 'Glace',
    'fighting': 'Combat',
    'poison': 'Poison',
    'ground': 'Sol',
    'flying': 'Vol',
    'psychic': 'Psy',
    'bug': 'Insecte',
    'rock': 'Roche',
    'ghost': 'Spectre',
    'dragon': 'Dragon',
    'dark': 'Ténèbres',
    'steel': 'Acier',
    'fairy': 'Fée',
  };

  static String _capitalize(String text) =>
      text.isNotEmpty ? text[0].toUpperCase() + text.substring(1) : text;

  static Future<String> _getEvolutionStage(String speciesUrl, String pokemonName) async {
    if (speciesUrl.isEmpty) {
      return 'Base';
    }
    final speciesResponse = await http.get(Uri.parse(speciesUrl));
    if (speciesResponse.statusCode != 200) {
      return 'Base';
    }
    final speciesData = json.decode(speciesResponse.body);

    // 1. Si is_baby
    if (speciesData['is_baby'] == true) {
      return 'Bébé';
    }

    // 2. Si pas d'évolution précédente
    if (speciesData['evolves_from_species'] == null) {
      if (speciesData['evolution_chain'] != null && speciesData['evolution_chain']['url'] != null) {
        final evolutionUrl = speciesData['evolution_chain']['url'] as String;
        final evolutionResponse = await http.get(Uri.parse(evolutionUrl));
        if (evolutionResponse.statusCode == 200) {
          final evolutionData = json.decode(evolutionResponse.body);
          if (_hasEvolvesTo(evolutionData['chain'], pokemonName)) {
            return 'Base';
          } else {
            return 'Finale';
          }
        }
      }
      return 'Base';
    } else {
      // Il évolue d'un autre
      if (speciesData['evolution_chain'] != null && speciesData['evolution_chain']['url'] != null) {
        final evolutionUrl = speciesData['evolution_chain']['url'] as String;
        final evolutionResponse = await http.get(Uri.parse(evolutionUrl));
        if (evolutionResponse.statusCode == 200) {
          final evolutionData = json.decode(evolutionResponse.body);
          if (_hasEvolvesTo(evolutionData['chain'], pokemonName)) {
            return 'Intermédiaire';
          } else {
            return 'Finale';
          }
        }
      }
      return 'Intermédiaire';
    }
  }

  /// Retourne true si le Pokémon (name anglais) a des évolutions possibles dans la chaîne
  static bool _hasEvolvesTo(Map<String, dynamic> node, String name) {
    String normalizeApiName(String s) => normalize(s.replaceAll('-', '').replaceAll("'", '').replaceAll('.', ''));
    if (normalizeApiName(node['species']['name']) == normalizeApiName(name)) {
      return node['evolves_to'] != null && (node['evolves_to'] as List).isNotEmpty;
    }
    if (node['evolves_to'] != null) {
      for (var child in node['evolves_to']) {
        if (_hasEvolvesTo(child, name)) return true;
      }
    }
    return false;
  }

  static Future<Pokemon> fetchRandomPokemon() async {
    final randomId = Random().nextInt(898) + 1;

    final response = await http.get(Uri.parse('$_baseUrl/pokemon/$randomId'));
    final speciesResponse = await http.get(Uri.parse('$_baseUrl/pokemon-species/$randomId'));

    if (response.statusCode != 200 || speciesResponse.statusCode != 200) {
      throw Exception('Erreur lors de la récupération du Pokémon.');
    }

    final data = json.decode(response.body);
    final speciesData = json.decode(speciesResponse.body);

    final name = _capitalize((speciesData['names'] as List?)
            ?.firstWhere((n) => n['language']['name'] == 'fr', orElse: () => {'name': data['name'] ?? 'Inconnu'})['name']
        ?? data['name'] ?? 'Inconnu');

    final types = (data['types'] as List?)?.map((t) {
      final typeEn = t['type']['name'] ?? 'Inconnu';
      return typeMap[typeEn] ?? _capitalize(typeEn);
    }).toList() ?? ['Inconnu'];

    final color = colorMap[speciesData['color']?['name'] ?? ''] ?? speciesData['color']?['name'] ?? 'Inconnu';
    final region = regionMap[speciesData['generation']?['name'] ?? ''] ?? speciesData['generation']?['name'] ?? 'Inconnu';

    final height = (data['height'] ?? 0) / 10;
    final size = height > 1.5 ? 'Grande' : 'Petite';

    final weight = (data['weight'] ?? 0) / 10;

    final description = ((speciesData['flavor_text_entries'] as List?)
            ?.firstWhere((entry) => entry['language']['name'] == 'fr', orElse: () => {'flavor_text': 'Pas de description disponible'})['flavor_text']
        ?? 'Pas de description disponible')
        .replaceAll('\n', ' ')
        .replaceAll('\f', ' ');

    final sprite = data['sprites']?['front_default'] ?? '';

    final shape = speciesData['shape'] != null
        ? (shapeMap[speciesData['shape']['name'] ?? ''] ?? speciesData['shape']['name'] ?? 'Inconnu')
        : 'Inconnu';

    final isLegendary = speciesData['is_legendary'] ?? false;

    final stadeEvolution = await _getEvolutionStage('https://pokeapi.co/api/v2/pokemon-species/${data['name']}/', data['name'] ?? name);

    return Pokemon(
      name: name,
      types: types,
      region: region,
      color: color,
      size: size,
      weight: weight,
      stadeEvolution: stadeEvolution,
      forme: shape,
      isLegendary: isLegendary,
      description: description,
      sprite: sprite,
    );
  }
}
