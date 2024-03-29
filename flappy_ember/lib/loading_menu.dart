import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'game.dart';

class LoadingMenu extends StatefulWidget {
  @override
  _LoadingMenuState createState() => _LoadingMenuState();
}

class _LoadingMenuState extends State<LoadingMenu>{
  List<Player> players = [
    Player(name: "Lionel Messi", position: "Delantero"),
    Player(name: "Cristiano Ronaldo", position: "Delantero"),
    Player(name: "Neymar Jr.", position: "Delantero"),
    Player(name: "Kylian Mbappé", position: "Delantero"),
    Player(name: "Robert Lewandowski", position: "Delantero"),
    Player(name: "Kevin De Bruyne", position: "Centrocampista"),
    Player(name: "Sergio Ramos", position: "Defensa"),
    Player(name: "Virgil van Dijk", position: "Defensa"),
    Player(name: "Mohamed Salah", position: "Delantero"),
    Player(name: "Sadio Mané", position: "Delantero"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Jugadores'),
      ),
      body: Center(
        child: Padding(padding: const EdgeInsets.all(50.0),
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 200,
              child: ListView.builder(
                itemCount: players.length,
                itemBuilder: (context, index) {
                  return Container(
                    height: 50,
                    child: PlayerListItem(player: players[index]),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final game = FlappyEmber();
                game.initializeGame(loadHud: true);

                final gameWidget = GameWidget(game: game);

                Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => gameWidget),
                );
              },
              child: Text('PLAY'),
            ),
          ],
        ))
        
      ),
    );
  }
}

class PlayerListItem extends StatelessWidget {
  final Player player;

  PlayerListItem({required this.player});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(player.name),
      subtitle: Text(player.position),
    );
  }
}

class Player {
  final String name;
  final String position;

  Player({required this.name, required this.position});
}