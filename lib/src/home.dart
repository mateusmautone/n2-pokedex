import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jogo_pokedex/src/classes/pokemon.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<Pokemon>> pokemons;
  int certos = 0;
  int errados = 0;
  int total = 0;
  bool initGame = false;
  bool fimDeJogo = false;
  TextStyle headerStyle = const TextStyle(
    fontSize: 26,
    // fontWeight: FontWeight.bold,
  );
  @override
  void initState() {
    super.initState();
    //Chama a função de buscar na API
    pokemons = fetchPokemons();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: pokemons,
      builder: ((context, snapshot) {
        //Verifica se já tem os dados
        if (snapshot.hasData) {
          //verifica se o jogo já foi iniciado
          if (initGame == false) {
            return Scaffold(
              body: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Bem vindo ao GameDex',
                      style: TextStyle(fontSize: 30),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            initGame = true;
                            certos = 0;
                            errados = 0;
                            total = 0;
                          });
                        },
                        child: const Text(
                          'Iniciar',
                          style: TextStyle(fontSize: 20),
                        )),
                  ],
                ),
              ),
            );
          }
          var pokemons = snapshot.data as List<Pokemon>;

          //ordena aleatoriamente a lista de pokemons
          pokemons.shuffle();

          //pega os 4 primeiros pokemons da lista
          var randomPokemons = pokemons.take(4).toList();

          //pega um numero aleatorio entre 0 e 3
          var randomNumber = Random().nextInt(4);
          //seleciona um pokemon aleatorio da lista
          var pokemon = randomPokemons[randomNumber];

          //verifica se o jogo chegou no fim
          if (total == 10) {
            return Container(
              constraints: const BoxConstraints.expand(),
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.background),
              child: AlertDialog(
                    title: const Text('Fim de jogo'),
                    content: Text('Você acertou $certos de 10'),
                    actions: [
                      TextButton(
                          onPressed: () {
                            // Navigator.pop(context);
                            setState(() {
                              initGame = false;
                              certos = 0;
                              errados = 0;
                              total = 0;
                            });
                          },
                          child: const Text('Fechar'))
                    ],
                  ),
            );
          }
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  Flex(
                    direction: Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Certos: $certos', style: headerStyle),
                      Text('Errados: $errados', style: headerStyle),
                    ],
                  ),
                  Image.network(pokemon.image!, scale: 0.9),
                  Flex(
                    direction: Axis.vertical,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: randomPokemons.map((e) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextButton(
                          onPressed: () async {
                            if (e.name == pokemon.name) {
                              mostrarAcertoErro(true);
                              setState(() {
                                certos++;
                                total++;
                              });
                            } else {
                              mostrarAcertoErro(false);
                              setState(() {
                                errados++;
                                total++;
                              });
                            }
                          },
                          style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all(
                                const Size(double.infinity, 60)),
                            backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).colorScheme.primary),
                            elevation: MaterialStateProperty.all(5),
                          ),
                          child: Text(
                            e.name,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 20),
                          ),
                        ),
                      );
                    }).toList(),
                  )
                ],
              ),
            ),
          );
        } else {
          //mensagem antes de iniciar o jogo
          return Scaffold(
            body: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Bem vindo ao GameDex',
                    style: TextStyle(fontSize: 30),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          initGame = true;
                          certos = 0;
                          errados = 0;
                          total = 0;
                        });
                      },
                      child: const Text(
                        'Iniciar',
                        style: TextStyle(fontSize: 20),
                      )),
                ],
              ),
            ),
          );
        }
      }),
    );
  }

  void mostrarAcertoErro(bool acerto) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor:
          acerto ? Colors.green : Theme.of(context).colorScheme.error,
      content: acerto ? const Text('Correto!') : const Text('Errado!'),
      behavior: SnackBarBehavior.floating,
      duration: Duration(milliseconds: 500),
    ));
  }
  Future<List<Pokemon>> fetchPokemons() async {
    //Chama a API
    final List<Pokemon> pokemons = [];
    final response = await http
        .get(Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=151'));
    if (response.statusCode == 200) {
      final pokemonList = jsonDecode(response.body);
      for (final item in pokemonList['results']) {
        pokemons.add(Pokemon.fromJson(item));
      }
      return pokemons;
    } else {
      throw Exception('Failed to load pokemons');
    }
  }
}
