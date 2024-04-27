import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_data.dart';
import 'utils_websockets.dart';

class FinishScreen extends StatefulWidget {
  late WebSocketsHandler websocket;
  late String winner;

  FinishScreen(this.websocket, this.winner);

  @override
  _FinishScreenState createState() => _FinishScreenState(websocket, winner);
}

class _FinishScreenState extends State<FinishScreen> {
  late WebSocketsHandler websocket;
  late String winner;

  _FinishScreenState(this.websocket, this.winner);

  @override
  Widget build(BuildContext context) {
    AppData appData = Provider.of<AppData>(context, listen: false);

    double fontSize = MediaQuery.of(context).size.width * 0.1;
    double winnerFontSize = MediaQuery.of(context).size.width * 0.05;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Game Over',
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20), // Separación entre los dos textos
            Text(
              'Winner: $winner',
              style: TextStyle(
                fontSize: winnerFontSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
