import 'package:jogo_pokedex/src/utils/constants.dart';

class Pokemon {
  final String name;
  final String url;

  get id => int.parse(url.split('/').reversed.skip(1).first);
  get image => '$pokemonImgUrl/$id.png';

  Pokemon({ required this.name, required this.url});

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(name: json['name'], url: json['url']);
  }
}
