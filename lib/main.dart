// main.dart

import 'package:flutter/material.dart';
import 'traffic_lights_game.dart';

void main() {
  runApp(const TrafficLightsApp());
}

class TrafficLightsApp extends StatelessWidget {
  const TrafficLightsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Traffic Lights',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const TrafficLightsScreen(),
    );
  }
}

class TrafficLightsScreen extends StatefulWidget {
  const TrafficLightsScreen({super.key});

  @override
  State<TrafficLightsScreen> createState() => _TrafficLightsScreenState();
}

class _TrafficLightsScreenState extends State<TrafficLightsScreen> {
  late TrafficLightsGame game;

  @override
  void initState() {
    super.initState();
    game = TrafficLightsGame();
  }

  Color _getColor(LightColor color) {
    switch (color) {
      case LightColor.off:
        return Colors.grey[300]!;
      case LightColor.green:
        return Colors.green;
      case LightColor.yellow:
        return Colors.yellow;
      case LightColor.red:
        return Colors.red;
    }
  }

  void _handleTap(int row, int col) {
    setState(() {
      if (game.makeMove(row, col)) {
        if (game.gameOver) {
          _showWinDialog();
        }
      }
    });
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Game Over!'),
        content: Text('Player ${game.currentPlayer} wins with ${_colorToString(game.winnerColor!)}!'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                game.reset();
              });
              Navigator.of(context).pop();
            },
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }

  String _colorToString(LightColor color) {
    switch (color) {
      case LightColor.off:
        return 'Off';
      case LightColor.green:
        return 'Green';
      case LightColor.yellow:
        return 'Yellow';
      case LightColor.red:
        return 'Red';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Traffic Lights'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                game.reset();
              });
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: List.generate(
                  game.rows,
                  (row) => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      game.cols,
                      (col) => GestureDetector(
                        onTap: () => _handleTap(row, col),
                        child: Container(
                          width: 60,
                          height: 60,
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: _getColor(game.board[row][col]),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              game.gameOver
                  ? 'Player ${game.currentPlayer} wins!'
                  : 'Player ${game.currentPlayer}\'s turn',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }
}
