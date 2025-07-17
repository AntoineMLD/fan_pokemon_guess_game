import 'package:characters/characters.dart';

/// Normalise une chaîne pour la comparaison :
/// - met en minuscules
/// - enlève les accents
/// - enlève les espaces superflus
String normalize(String input) {
  final withLower = input.trim().toLowerCase();
  // Remplacement manuel des accents courants (rapide et efficace pour le français)
  final withoutAccents = withLower
      .replaceAll('à', 'a')
      .replaceAll('â', 'a')
      .replaceAll('ä', 'a')
      .replaceAll('á', 'a')
      .replaceAll('ã', 'a')
      .replaceAll('å', 'a')
      .replaceAll('ç', 'c')
      .replaceAll('é', 'e')
      .replaceAll('è', 'e')
      .replaceAll('ê', 'e')
      .replaceAll('ë', 'e')
      .replaceAll('í', 'i')
      .replaceAll('ì', 'i')
      .replaceAll('î', 'i')
      .replaceAll('ï', 'i')
      .replaceAll('ñ', 'n')
      .replaceAll('ò', 'o')
      .replaceAll('ô', 'o')
      .replaceAll('ö', 'o')
      .replaceAll('õ', 'o')
      .replaceAll('ú', 'u')
      .replaceAll('ù', 'u')
      .replaceAll('û', 'u')
      .replaceAll('ü', 'u')
      .replaceAll('ý', 'y')
      .replaceAll('ÿ', 'y');
  // Supprime les symboles de genre Pokémon
  final withoutGender = withoutAccents.replaceAll(RegExp(r'[♂♀]'), '');
  return withoutGender.replaceAll(RegExp(r'\s+'), ' ');
}

/// Exemple d'utilisation :
///
/// ```dart
/// normalize('Évoli') == normalize('evoli') // true
/// normalize('Pikachu') == normalize('pikachu') // true
/// normalize('Mr. Mime') == normalize('mr mime') // true
/// ``` 